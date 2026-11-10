output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "kubernetes_version" {
  description = "Versão do Kubernetes do control plane"
  value       = module.eks.kubernetes_version
}

output "karpenter_node_role_name" {
  description = "Role dos nós do Karpenter; vai no spec.role do EC2NodeClass"
  value       = module.karpenter.node_role_name
}

output "jobs_queue_url" {
  description = "URL da fila de trabalho (vai no ScaledObject e no Deployment)"
  value       = aws_sqs_queue.jobs.url
}

output "jobs_dlq_url" {
  description = "URL da fila de mensagens com falha"
  value       = aws_sqs_queue.jobs_dlq.url
}

output "keda_operator_role_arn" {
  description = "Role do operator do KEDA (Pod Identity, só GetQueueAttributes)"
  value       = module.keda.operator_role_arn
}

output "worker_role_arn" {
  description = "Role do consumidor (Pod Identity em jobs/worker)"
  value       = module.worker_identity.role_arn
}

output "keda_chart_version" {
  description = "Versão do chart do KEDA"
  value       = module.keda.chart_version
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
