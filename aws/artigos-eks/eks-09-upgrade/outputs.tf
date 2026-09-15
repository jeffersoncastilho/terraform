output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "cluster_version" {
  description = "Versão do control plane depois do apply"
  value       = module.eks.kubernetes_version
}

output "node_group_name" {
  description = "Nome do managed node group (para acompanhar o update com aws eks list-updates)"
  value       = module.ng_default.node_group_name
}

output "addon_versions" {
  description = "Versão instalada de cada add-on; registre antes e depois do upgrade"
  value       = module.addons.addon_versions
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
