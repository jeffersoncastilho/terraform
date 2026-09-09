output "id" {
  description = "ID do Virtual Network Gateway"
  value       = azurerm_virtual_network_gateway.this.id
}

output "name" {
  description = "Nome do Virtual Network Gateway"
  value       = azurerm_virtual_network_gateway.this.name
}
