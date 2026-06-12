output "cluster_id" {
  description = "ID do AKS Cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Nome do AKS Cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "kube_config_raw" {
  description = "Kubeconfig completo do cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kubelet_identity_object_id" {
  description = "Object ID da managed identity do kubelet"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "oidc_issuer_url" {
  description = "URL do OIDC issuer para Workload Identity"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}
