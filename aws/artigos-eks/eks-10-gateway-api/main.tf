# Gateway API no EKS com o AWS Load Balancer Controller.
# Série artigos-eks | Artigo: eks-10-gateway-api
#
# Mesma base do eks-06 (VPC, cluster, node group, add-ons e controller via
# Helm + Pod Identity). A diferença está no Kubernetes: em vez de Ingress, o
# ALB nasce de um Gateway + HTTPRoute. Os CRDs da Gateway API e os CRDs do
# controller (LoadBalancerConfiguration, TargetGroupConfiguration,
# ListenerRuleConfiguration) são aplicados com kubectl depois do apply.

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
