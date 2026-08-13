output "registry_id" {
  description = "ID do Container Registry"
  value       = azurerm_container_registry.this.id
}

output "registry_name" {
  description = "Nome do Container Registry"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "URL do login server do ACR"
  value       = azurerm_container_registry.this.login_server
}

output "admin_username" {
  description = "Admin username do Container Registry (requer admin_enabled = true)"
  value       = azurerm_container_registry.this.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "Admin password do Container Registry (requer admin_enabled = true)"
  value       = azurerm_container_registry.this.admin_password
  sensitive   = true
}
