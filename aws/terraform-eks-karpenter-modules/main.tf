# Karpenter no EKS: role dos nós + access entry EC2_LINUX, role do controller
# via EKS Pod Identity, fila SQS de interrupção alimentada pelo EventBridge e o
# chart oficial (oci://public.ecr.aws/karpenter/karpenter).
#
# A política do controller (controller-policy.json.tftpl) e os recursos de
# interrupção são a tradução para Terraform do cloudformation.yaml publicado
# pelo projeto no guia "Getting Started with Karpenter" da mesma versão.
# Ao subir chart_version, compare com o cloudformation.yaml da nova tag.

data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.region
  account_id = data.aws_caller_identity.current.account_id
}

# ── Nós criados pelo Karpenter ────────────────────────────────────────────────

data "aws_iam_policy_document" "node_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node" {
  name               = "KarpenterNodeRole-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.node_assume.json
  tags               = var.tags
}

# Chaves fixas no for_each: a partition só é conhecida no apply quando o
# módulo é chamado com depends_on, e chave de for_each precisa ser conhecida
# no plan.
resource "aws_iam_role_policy_attachment" "node" {
  for_each = toset([
    "AmazonEKS_CNI_Policy",
    "AmazonEKSWorkerNodePolicy",
    "AmazonEC2ContainerRegistryPullOnly",
    "AmazonSSMManagedInstanceCore",
  ])
  role       = aws_iam_role.node.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/${each.value}"
}

# Sem esta access entry, o nó sobe mas não consegue se registrar no cluster.
# Tipo EC2_LINUX: o EKS coloca o nó no grupo system:nodes automaticamente.
resource "aws_eks_access_entry" "node" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.node.arn
  type          = "EC2_LINUX"
  tags          = var.tags
}

# ── Interrupções: Spot, manutenção agendada, rebalance, mudança de estado ────

resource "aws_sqs_queue" "interruption" {
  name                      = var.cluster_name
  message_retention_seconds = 300
  sqs_managed_sse_enabled   = true
  tags                      = var.tags
}

data "aws_iam_policy_document" "queue" {
  statement {
    sid       = "EC2InterruptionPolicy"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.interruption.arn]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }
  }

  statement {
    sid       = "DenyHTTP"
    effect    = "Deny"
    actions   = ["sqs:*"]
    resources = [aws_sqs_queue.interruption.arn]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_sqs_queue_policy" "interruption" {
  queue_url = aws_sqs_queue.interruption.url
  policy    = data.aws_iam_policy_document.queue.json
}

locals {
  interruption_events = {
    scheduled-change     = { source = "aws.health", detail_type = "AWS Health Event" }
    spot-interruption    = { source = "aws.ec2", detail_type = "EC2 Spot Instance Interruption Warning" }
    rebalance            = { source = "aws.ec2", detail_type = "EC2 Instance Rebalance Recommendation" }
    instance-state       = { source = "aws.ec2", detail_type = "EC2 Instance State-change Notification" }
    capacity-reservation = { source = "aws.ec2", detail_type = "EC2 Capacity Reservation Instance Interruption Warning" }
  }
}

resource "aws_cloudwatch_event_rule" "interruption" {
  for_each = local.interruption_events

  name = "karpenter-${var.cluster_name}-${each.key}"
  event_pattern = jsonencode({
    source        = [each.value.source]
    "detail-type" = [each.value.detail_type]
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "interruption" {
  for_each = local.interruption_events

  rule      = aws_cloudwatch_event_rule.interruption[each.key].name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.interruption.arn
}

# ── Controller ────────────────────────────────────────────────────────────────

module "pod_identity" {
  source = "../terraform-eks-pod-identity-modules"

  cluster_name = var.cluster_name
  role_name    = "KarpenterController-${var.cluster_name}"

  service_accounts = [
    { namespace = var.namespace, name = var.service_account_name },
  ]

  # jsonencode(jsondecode(...)) só compacta o JSON (limite de tamanho de
  # política inline por role).
  inline_policy_json = jsonencode(jsondecode(templatefile("${path.module}/controller-policy.json.tftpl", {
    partition     = local.partition
    region        = local.region
    account_id    = local.account_id
    cluster_name  = var.cluster_name
    node_role_arn = aws_iam_role.node.arn
    queue_arn     = aws_sqs_queue.interruption.arn
  })))

  tags = var.tags
}

resource "helm_release" "this" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = var.chart_version
  namespace  = var.namespace

  set = [
    { name = "settings.clusterName", value = var.cluster_name },
    { name = "settings.interruptionQueue", value = aws_sqs_queue.interruption.name },
    { name = "serviceAccount.name", value = var.service_account_name },
    { name = "replicas", value = tostring(var.replicas) },
    { name = "controller.resources.requests.cpu", value = "500m" },
    { name = "controller.resources.requests.memory", value = "512Mi" },
    { name = "controller.resources.limits.memory", value = "512Mi" },
  ]

  depends_on = [
    module.pod_identity,
    aws_eks_access_entry.node,
    aws_cloudwatch_event_target.interruption,
  ]
}
