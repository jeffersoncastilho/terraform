output "acr_login_server" {
  description = "Login server do Container Registry"
  value       = module.acr.login_server
}

output "aks_brazilsouth_name" {
  description = "Nome do AKS Cluster Brazil South"
  value       = module.aks_brazilsouth.cluster_name
}

output "aks_eastus_name" {
  description = "Nome do AKS Cluster East US"
  value       = module.aks_eastus.cluster_name
}

output "aks_brazilsouth_oidc_issuer" {
  description = "OIDC Issuer URL do AKS Brazil South"
  value       = module.aks_brazilsouth.oidc_issuer_url
}

output "aks_eastus_oidc_issuer" {
  description = "OIDC Issuer URL do AKS East US"
  value       = module.aks_eastus.oidc_issuer_url
}
