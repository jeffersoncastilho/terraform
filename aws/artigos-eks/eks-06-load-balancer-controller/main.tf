# AWS Load Balancer Controller via Helm + EKS Pod Identity.
# Série artigos-eks | Artigo: eks-06-load-balancer-controller
#
# Mesmo cluster base do eks-01. A peça nova é o controller, que transforma
# Ingress em Application Load Balancer. As tags kubernetes.io/role/elb e
# kubernetes.io/role/internal-elb que o terraform-vpc-modules põe nas subnets
# são o que o controller usa para escolher onde criar o ALB.

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

# O controller depende do agente do Pod Identity (credencial) e dos nós
# (onde os pods rodam), por isso vem depois dos add-ons.
module "lb_controller" {
  source = "../../terraform-eks-lb-controller-modules"

  cluster_name  = module.eks.name
  region        = var.region
  vpc_id        = module.vpc.vpc_id
  chart_version = var.lb_controller_chart_version

  depends_on = [module.addons]
}
