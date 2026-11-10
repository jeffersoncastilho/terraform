# KEDA no EKS escalando pods por fila SQS. Série artigos-eks | Artigo: eks-11-keda
#
# Mesmo cluster do eks-07: node group "system" fixo e Karpenter para os nós da
# aplicação. Em cima dele:
# - fila SQS "jobs" (com DLQ) que a aplicação consome;
# - KEDA no namespace keda, com a role do operator via Pod Identity lendo só
#   os atributos da fila;
# - role do consumidor (namespace jobs, service account worker) via Pod
#   Identity, para receber e apagar mensagens.
# O KEDA escala os pods pela fila; os pods sem lugar fazem o Karpenter criar nós.

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

# ── Fila de trabalho ──────────────────────────────────────────────────────────

# Mensagem que falha 5 vezes vai para a DLQ em vez de voltar para a fila para
# sempre (e manter o KEDA escalando por causa dela).
resource "aws_sqs_queue" "jobs_dlq" {
  name                      = "jobs-dlq-${var.cluster_name}"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true
}

resource "aws_sqs_queue" "jobs" {
  name                       = "jobs-${var.cluster_name}"
  visibility_timeout_seconds = 60
  receive_wait_time_seconds  = 20
  sqs_managed_sse_enabled    = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.jobs_dlq.arn
    maxReceiveCount     = 5
  })
}

# ── KEDA ──────────────────────────────────────────────────────────────────────

module "keda" {
  source = "../../terraform-eks-keda-modules"

  cluster_name   = module.eks.name
  chart_version  = var.keda_chart_version
  sqs_queue_arns = [aws_sqs_queue.jobs.arn]
  node_selector  = { "node-role" = "system" }

  depends_on = [module.addons]
}

# ── Consumidor ────────────────────────────────────────────────────────────────

locals {
  worker_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ConsumeJobs"
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
      ]
      Resource = aws_sqs_queue.jobs.arn
    }]
  })
}

module "worker_identity" {
  source = "../../terraform-eks-pod-identity-modules"

  cluster_name = module.eks.name
  role_name    = "JobsWorker-${var.cluster_name}"
  service_accounts = [
    { namespace = "jobs", name = "worker" },
  ]
  inline_policy_json = local.worker_policy_json

  depends_on = [module.addons]
}
