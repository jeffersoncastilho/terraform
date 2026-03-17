# Controle de acesso ao cluster EKS com Access Entries (sem ConfigMap aws-auth).
# Série: artigos-eks | Artigo: eks-03-access-entries
#
# Três perfis de acesso:
# - plataforma: admin do cluster inteiro (access policy gerenciada).
# - time da loja: edição só no namespace "loja" (access policy com escopo).
# - deploy da loja: grupo do Kubernetes "loja-deployers", com permissão
#   definida por RBAC próprio (k8s/rbac-loja-deployers.yaml).

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

  # API = só Access Entries. Em cluster antigo, migre passando por
  # API_AND_CONFIG_MAP (o EKS não permite voltar de API para CONFIG_MAP).
  authentication_mode = var.authentication_mode

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

  depends_on = [module.ng_default]
}

module "access" {
  source = "../../terraform-eks-access-entry-modules"

  cluster_name = module.eks.name

  access_entries = {
    plataforma = {
      principal_arn = var.platform_admin_role_arn
      policies = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        }
      }
    }

    time-loja = {
      principal_arn = var.team_role_arn
      policies = {
        edit = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          scope_type = "namespace"
          namespaces = ["loja"]
        }
      }
    }

    deploy-loja = {
      principal_arn     = var.deploy_role_arn
      kubernetes_groups = ["loja-deployers"]
    }
  }
}
