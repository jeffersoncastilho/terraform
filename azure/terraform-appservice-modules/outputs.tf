# Outputs do módulo terraform-appservice-modules

output "plan_id" {
  description = "ID do App Service Plan"
  value       = azurerm_service_plan.this.id
}

output "app_id" {
  description = "ID do Web App"
  value       = azurerm_linux_web_app.this.id
}

output "app_name" {
  description = "Nome do Web App"
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "Hostname público padrão do Web App (*.azurewebsites.net)"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "resource_group_name" {
  description = "Resource Group onde os recursos foram criados"
  value       = var.resource_group_name
}

output "principal_id" {
  description = "Principal ID da identidade gerenciada (null se identity_type não foi definido)"
  value       = try(azurerm_linux_web_app.this.identity[0].principal_id, null)
}
