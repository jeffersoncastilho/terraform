output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "cluster_endpoint" {
  description = "Endpoint da API do Kubernetes"
  value       = module.eks.endpoint
}

output "kubernetes_version" {
  description = "Versão do Kubernetes do control plane"
  value       = module.eks.kubernetes_version
}

output "vpc_id" {
  description = "ID da VPC do cluster"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Subnets privadas onde rodam os nós"
  value       = module.vpc.private_subnet_ids
}

output "node_role_arn" {
  description = "ARN da IAM role dos nós do node group default"
  value       = module.ng_default.node_role_arn
}

output "addon_versions" {
  description = "Versão instalada de cada add-on gerenciado"
  value       = module.addons.addon_versions
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
