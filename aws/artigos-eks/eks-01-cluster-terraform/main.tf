# EKS com Terraform do zero: VPC + control plane + managed node group + add-ons
# básicos. Primeiro artigo da série artigos-eks; os próximos reaproveitam este
# mesmo cluster e acrescentam uma peça por vez.
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

# CoreDNS só fica ACTIVE quando existe nó para rodar os pods, por isso os
# add-ons dependem do node group.
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
