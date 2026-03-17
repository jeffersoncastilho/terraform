output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "access_entry_arns" {
  description = "ARNs das access entries criadas, por perfil"
  value       = module.access.access_entry_arns
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
