output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "catalogo_role_arn" {
  description = "ARN da IAM role assumida pelos pods da service account loja/catalogo"
  value       = module.pi_catalogo.role_arn
}

output "pod_identity_associations" {
  description = "IDs das Pod Identity associations, por namespace/service account"
  value       = module.pi_catalogo.association_ids
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
