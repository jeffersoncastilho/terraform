output "cluster_name" {
  description = "Nome do cluster EKS (valor da tag karpenter.sh/discovery)"
  value       = module.eks.name
}

output "kubernetes_version" {
  description = "Versão do Kubernetes do control plane"
  value       = module.eks.kubernetes_version
}

output "karpenter_node_role_name" {
  description = "Role dos nós criados pelo Karpenter; vai no spec.role do EC2NodeClass"
  value       = module.karpenter.node_role_name
}

output "karpenter_controller_role_arn" {
  description = "ARN da IAM role do controller do Karpenter (via Pod Identity)"
  value       = module.karpenter.controller_role_arn
}

output "interruption_queue_name" {
  description = "Fila SQS que recebe avisos de interrupção Spot e manutenção"
  value       = module.karpenter.interruption_queue_name
}

output "karpenter_chart_version" {
  description = "Versão do chart do Karpenter"
  value       = module.karpenter.chart_version
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
