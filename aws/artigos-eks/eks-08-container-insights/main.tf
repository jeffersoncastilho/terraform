# Container Insights no EKS: add-on amazon-cloudwatch-observability com
# permissões via EKS Pod Identity (sem provedor OIDC, sem anotar service
# account). O add-on instala o CloudWatch agent (métricas da observabilidade
# aprimorada) e o Fluent Bit (logs de container) como DaemonSets.
# Série: artigos-eks | Artigo: eks-08-container-insights
#
# Composição de módulos reutilizáveis:
# terraform-vpc-modules, terraform-eks-modules,
# terraform-eks-node-group-modules, terraform-eks-pod-identity-modules e
# terraform-eks-addon-modules.

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

# Log groups criados antes do add-on, com retenção definida. Se o Fluent Bit
# criar sozinho, eles nascem com retenção "nunca expira" e o custo de
# armazenamento só cresce.
resource "aws_cloudwatch_log_group" "container_insights" {
  for_each = toset(["application", "dataplane", "host", "performance"])

  name              = "/aws/containerinsights/${var.cluster_name}/${each.key}"
  retention_in_days = var.log_retention_days
}

# Role do CloudWatch agent. service_accounts vazio: a associação com a service
# account cloudwatch-agent é feita pelo próprio add-on (bloco
# pod_identity_association), não aqui, para não haver associação duplicada.
module "pi_cloudwatch" {
  source = "../../terraform-eks-pod-identity-modules"

  cluster_name     = module.eks.name
  role_name        = "${var.cluster_name}-cloudwatch-agent"
  service_accounts = []

  policy_arns = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
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
    amazon-cloudwatch-observability = {
      pod_identity_role_arn = module.pi_cloudwatch.role_arn
      service_account       = "cloudwatch-agent"
      configuration_values = jsonencode({
        containerLogs = { enabled = var.enable_container_logs }
      })
    }
  }

  depends_on = [module.ng_default, aws_cloudwatch_log_group.container_insights]
}
