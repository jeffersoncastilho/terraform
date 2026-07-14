# Karpenter com Spot no EKS. Série artigos-eks | Artigo: eks-07-karpenter
#
# Mesmo cluster base do eks-01, com duas diferenças:
# - o node group gerenciado vira "system": pequeno, fixo, só para CoreDNS,
#   Karpenter e outros controllers. Karpenter não pode rodar em nó que ele
#   mesmo gerencia (se o nó for consolidado, o controller cai junto).
# - subnets privadas e security group do cluster recebem a tag
#   karpenter.sh/discovery, que o EC2NodeClass usa para achar onde criar nós.

module "vpc" {
  source = "../../terraform-vpc-modules"

  name               = "vpc-${var.cluster_name}"
  cidr_block         = var.vpc_cidr
  az_count           = 2
  single_nat_gateway = true

  private_subnet_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }
}

module "eks" {
  source = "../../terraform-eks-modules"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids         = module.vpc.private_subnet_ids

  public_access_cidrs = var.public_access_cidrs
}

# Security group criado pelo próprio EKS: o Terraform não o gerencia, só
# acrescenta a tag de descoberta.
resource "aws_ec2_tag" "cluster_sg_discovery" {
  resource_id = module.eks.cluster_security_group_id
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}

module "ng_system" {
  source = "../../terraform-eks-node-group-modules"

  cluster_name   = module.eks.name
  name           = "system"
  subnet_ids     = module.vpc.private_subnet_ids
  instance_types = ["t3.medium"]

  min_size     = 2
  desired_size = 2
  max_size     = 2

  labels = { "node-role" = "system" }
}

module "addons" {
  source = "../../terraform-eks-addon-modules"

  cluster_name       = module.eks.name
  kubernetes_version = module.eks.kubernetes_version

  addons = {
    vpc-cni                = {}
    coredns                = {}
    kube-proxy             = {}
    eks-pod-identity-agent = {}
  }

  depends_on = [module.ng_system]
}

module "karpenter" {
  source = "../../terraform-eks-karpenter-modules"

  cluster_name  = module.eks.name
  chart_version = var.karpenter_chart_version

  depends_on = [module.addons]
}
