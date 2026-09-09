output "id" {
  description = "ID do Public IP"
  value       = azurerm_public_ip.this.id
}

output "ip_address" {
  description = "Endereço IP alocado (known after apply)"
  value       = azurerm_public_ip.this.ip_address
}

output "name" {
  description = "Nome do Public IP"
  value       = azurerm_public_ip.this.name
}
