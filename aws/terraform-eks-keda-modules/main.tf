# KEDA no EKS: chart oficial (https://kedacore.github.io/charts) e, opcional,
# role do operator via EKS Pod Identity para os scalers da AWS (SQS, CloudWatch).
#
# Com podIdentity.provider = aws e sem roleArn na TriggerAuthentication, o
# KEDA usa a cadeia padrão de credenciais do AWS SDK, que já entende o EKS
# Pod Identity. Por isso a permissão fica na role do operator: ele é quem lê
# a fila, não o pod da aplicação.

# Só leitura dos atributos da fila: é o que o scaler aws-sqs-queue usa para
# contar mensagens visíveis e em processamento. jsonencode (e não um data
# source) porque o count do módulo de Pod Identity precisa saber já no plan
# que a política existe.
locals {
  operator_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "ReadQueueDepth"
      Effect   = "Allow"
      Action   = ["sqs:GetQueueAttributes", "sqs:GetQueueUrl"]
      Resource = var.sqs_queue_arns
    }]
  })
}

module "pod_identity" {
  source = "../terraform-eks-pod-identity-modules"
  count  = length(var.sqs_queue_arns) > 0 ? 1 : 0

  cluster_name = var.cluster_name
  role_name    = "KedaOperator-${var.cluster_name}"
  service_accounts = [
    { namespace = var.namespace, name = "keda-operator" },
  ]
  inline_policy_json = local.operator_policy_json
  tags               = var.tags
}

resource "helm_release" "this" {
  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  # O nodeSelector global vale para operator, metrics server e webhooks:
  # o KEDA fica nos nós fixos, longe dos nós que ele mesmo faz o Karpenter criar.
  values = [yamlencode({
    nodeSelector = var.node_selector
    operator     = { replicaCount = var.operator_replicas }
  })]

  # A associação do Pod Identity precisa existir antes de o pod do operator
  # nascer: as credenciais são injetadas na criação do pod.
  depends_on = [module.pod_identity]
}
