output "id" {
  description = "ID do Private Link Service"
  value       = azurerm_private_link_service.this.id
}

output "name" {
  description = "Nome do Private Link Service"
  value       = azurerm_private_link_service.this.name
}

output "alias" {
  description = "Alias do Private Link Service — usado por consumidores para referenciar o serviço por alias em vez de resource ID"
  value       = azurerm_private_link_service.this.alias
}
