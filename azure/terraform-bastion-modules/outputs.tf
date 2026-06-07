output "bastion_id" {
  description = "ID do Azure Bastion Host"
  value       = azurerm_bastion_host.this.id
}

output "bastion_name" {
  description = "Nome do Azure Bastion Host"
  value       = azurerm_bastion_host.this.name
}

output "public_ip_id" {
  description = "ID do Public IP do Bastion"
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "Endereço IP público do Bastion"
  value       = azurerm_public_ip.this.ip_address
}
