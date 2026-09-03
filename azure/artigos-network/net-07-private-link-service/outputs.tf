output "private_link_service_alias" {
  value = azurerm_private_link_service.this.alias
}

output "private_endpoint_connection_status" {
  value = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}
