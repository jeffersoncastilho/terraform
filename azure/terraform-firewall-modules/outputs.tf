output "firewall_id" {
  description = "ID do Azure Firewall"
  value       = azurerm_firewall.this.id
}

output "firewall_name" {
  description = "Nome do Azure Firewall"
  value       = azurerm_firewall.this.name
}

output "private_ip_address" {
  description = "IP privado do Firewall — usado como next hop nas Route Tables"
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

output "public_ip_address" {
  description = "IP publico do Firewall"
  value       = azurerm_public_ip.this.ip_address
}

output "policy_id" {
  description = "ID da Firewall Policy"
  value       = azurerm_firewall_policy.this.id
}
