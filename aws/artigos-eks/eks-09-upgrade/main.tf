# Upgrade do EKS sem downtime: control plane, add-ons e node group com versões
# separadas, para subir uma etapa por vez (1.35 → 1.36).
# Série: artigos-eks | Artigo: eks-09-upgrade
#
# Ordem do upgrade:
#   1. cluster_version = "1.36"  → apply: control plane e add-ons (os add-ons
#      seguem a versão do cluster e pegam a mais recente compatível)
#   2. node_group_version = "1.36" → apply: o managed node group troca os nós
#      aos poucos, respeitando max_unavailable_percentage e os PodDisruptionBudgets
#
# Composição de módulos reutilizáveis:
# terraform-vpc-modules, terraform-eks-modules,
# terraform-eks-node-group-modules e terraform-eks-addon-modules.

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
  kubernetes_version = var.cluster_version
  subnet_ids         = module.vpc.private_subnet_ids
  support_type       = var.support_type

  public_access_cidrs = var.public_access_cidrs
}

module "ng_default" {
  source = "../../terraform-eks-node-group-modules"

  cluster_name       = module.eks.name
  name               = "default"
  subnet_ids         = module.vpc.private_subnet_ids
  instance_types     = ["t3.medium"]
  kubernetes_version = var.node_group_version

  min_size     = 2
  desired_size = 3
  max_size     = 4

  # Troca no máximo um terço dos nós por vez durante o upgrade.
  max_unavailable_percentage = 33
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
