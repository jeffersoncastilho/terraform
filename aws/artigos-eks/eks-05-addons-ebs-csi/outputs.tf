output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "kubernetes_version" {
  description = "Versão do Kubernetes do control plane"
  value       = module.eks.kubernetes_version
}

output "addon_versions" {
  description = "Versão instalada de cada add-on"
  value       = module.addons.addon_versions
}

output "ebs_csi_role_arn" {
  description = "IAM role usada pelo controller do EBS CSI (via Pod Identity)"
  value       = module.pi_ebs_csi.role_arn
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
