output "id" {
  description = "ID do Container Group"
  value       = azurerm_container_group.this.id
}

output "name" {
  description = "Nome do Container Group"
  value       = azurerm_container_group.this.name
}

output "ip_address" {
  description = "IP público do Container Group (se atribuído)"
  value       = azurerm_container_group.this.ip_address
}

output "fqdn" {
  description = "FQDN do Container Group (se DNS label configurado)"
  value       = azurerm_container_group.this.fqdn
}
