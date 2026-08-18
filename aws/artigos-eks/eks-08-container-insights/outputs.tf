output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "addon_versions" {
  description = "Versão instalada de cada add-on, inclusive o amazon-cloudwatch-observability"
  value       = module.addons.addon_versions
}

output "cloudwatch_agent_role_arn" {
  description = "ARN da IAM role usada pelo CloudWatch agent via EKS Pod Identity"
  value       = module.pi_cloudwatch.role_arn
}

output "log_groups" {
  description = "Log groups do Container Insights criados com retenção definida"
  value       = [for g in aws_cloudwatch_log_group.container_insights : g.name]
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
