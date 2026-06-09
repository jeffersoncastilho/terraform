output "id" {
  description = "ID da Private DNS Zone"
  value       = azurerm_private_dns_zone.this.id
}

output "name" {
  description = "Nome da Private DNS Zone"
  value       = azurerm_private_dns_zone.this.name
}
