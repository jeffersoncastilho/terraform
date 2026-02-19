# outputs.tf

output "id" {
  description = "O ID do Grupo de Recursos."
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "O nome do Grupo de Recursos."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "A localização do Grupo de Recursos."
  value       = azurerm_resource_group.this.location
}