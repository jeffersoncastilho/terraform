# Managed Node Groups On-Demand × Spot no mesmo cluster EKS.
# Série: artigos-eks | Artigo: eks-02-managed-node-groups
#
# Dois node groups com papéis diferentes:
# - "system" (ON_DEMAND): add-ons e cargas que não podem ser interrompidas.
# - "spot" (SPOT): cargas tolerantes a interrupção, com taint para que só
#   entrem pods que declarem a toleration.

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

module "ng_system" {
  source = "../../terraform-eks-node-group-modules"

  cluster_name   = module.eks.name
  name           = "system"
  subnet_ids     = module.vpc.private_subnet_ids
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  min_size     = 2
  desired_size = 2
  max_size     = 3

  labels = {
    "workload" = "system"
  }
}

module "ng_spot" {
  source = "../../terraform-eks-node-group-modules"

  cluster_name  = module.eks.name
  name          = "spot"
  subnet_ids    = module.vpc.private_subnet_ids
  capacity_type = "SPOT"

  # Vários tipos com o mesmo tamanho (2 vCPU / 8 GiB): mais pools de
  # capacidade Spot, menos chance de ficar sem nó quando um pool esgota.
  instance_types = var.spot_instance_types

  min_size     = 0
  desired_size = 2
  max_size     = 6

  # Substitui no máximo 1 nó por vez num update (versão, AMI, launch template).
  max_unavailable_percentage = 25

  labels = {
    "workload" = "spot"
  }

  taints = [
    {
      key    = "workload"
      value  = "spot"
      effect = "NO_SCHEDULE"
    },
  ]
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
