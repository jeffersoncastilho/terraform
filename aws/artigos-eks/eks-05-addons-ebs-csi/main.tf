# Add-ons do EKS gerenciados pelo Terraform + aws-ebs-csi-driver com
# EKS Pod Identity. Série artigos-eks | Artigo: eks-05-addons-ebs-csi
#
# Mesmo cluster base do eks-01 (VPC + control plane + node group). A peça nova
# é o driver CSI do EBS: o add-on roda com a role criada por
# terraform-eks-pod-identity-modules, sem provedor OIDC e sem anotar a
# service account. A StorageClass gp3 padrão fica no YAML do artigo.

module "vpc" {
  source = "../../terraform-vpc-modules"

  name               = "vpc-${var.cluster_name}"
  cidr_block         = var.vpc_cidr
  az_count           = 2
  single_nat_gateway = true
}

module "eks" {
  source = "../../terraform-eks-modules"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids         = module.vpc.private_subnet_ids

  public_access_cidrs = var.public_access_cidrs
}

module "ng_default" {
  source = "../../terraform-eks-node-group-modules"

  cluster_name   = module.eks.name
  name           = "default"
  subnet_ids     = module.vpc.private_subnet_ids
  instance_types = ["t3.medium"]

  min_size     = 1
  desired_size = 2
  max_size     = 3
}

# Role do controller do EBS CSI. A política gerenciada da AWS cobre criar,
# anexar, redimensionar e apagar volumes e snapshots.
module "pi_ebs_csi" {
  source = "../../terraform-eks-pod-identity-modules"

  cluster_name = module.eks.name
  role_name    = "${var.cluster_name}-ebs-csi"

  # A associação é feita pelo próprio add-on (pod_identity_association),
  # por isso nenhuma service account é listada aqui.
  service_accounts = []

  policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
}

module "addons" {
  source = "../../terraform-eks-addon-modules"

  cluster_name       = module.eks.name
  kubernetes_version = module.eks.kubernetes_version

  addons = {
    vpc-cni = {
      version = var.vpc_cni_version
    }
    coredns                = {}
    kube-proxy             = {}
    eks-pod-identity-agent = {}

    aws-ebs-csi-driver = {
      pod_identity_role_arn = module.pi_ebs_csi.role_arn
      service_account       = "ebs-csi-controller-sa"

      # Toda configuração aceita está no schema:
      # aws eks describe-addon-configuration --addon-name aws-ebs-csi-driver --addon-version <versão>
      configuration_values = jsonencode({
        controller = {
          extraVolumeTags = {
            cluster    = var.cluster_name
            managed_by = "ebs-csi"
          }
        }
      })
    }
  }

  depends_on = [module.ng_default]
}
