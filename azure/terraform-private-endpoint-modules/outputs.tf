output "id" {
  description = "ID do Private Endpoint"
  value       = azurerm_private_endpoint.this.id
}

output "private_ip_address" {
  description = "IP privado atribuído ao Private Endpoint"
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}
