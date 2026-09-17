output "id" {
  description = "ID do Network Manager"
  value       = azurerm_network_manager.this.id
}

output "network_group_id" {
  description = "ID do grupo de rede"
  value       = azurerm_network_manager_network_group.this.id
}
