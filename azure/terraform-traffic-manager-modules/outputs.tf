output "profile_id" {
  description = "ID do Traffic Manager Profile"
  value       = azurerm_traffic_manager_profile.this.id
}

output "profile_name" {
  description = "Nome do Traffic Manager Profile"
  value       = azurerm_traffic_manager_profile.this.name
}

output "fqdn" {
  description = "FQDN do Traffic Manager (nome.trafficmanager.net)"
  value       = azurerm_traffic_manager_profile.this.fqdn
}
