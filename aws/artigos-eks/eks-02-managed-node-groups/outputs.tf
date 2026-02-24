output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "node_groups" {
  description = "Node groups criados"
  value = {
    system = module.ng_system.node_group_name
    spot   = module.ng_spot.node_group_name
  }
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
