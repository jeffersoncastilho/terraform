output "ddos_plan_id" {
  value = azurerm_network_ddos_protection_plan.this.id
}

output "protected_public_ip" {
  value = azurerm_public_ip.protected.ip_address
}
