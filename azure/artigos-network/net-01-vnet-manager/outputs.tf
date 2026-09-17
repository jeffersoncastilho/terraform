output "network_manager_id" {
  value = azurerm_network_manager.this.id
}

output "network_group_id" {
  value = azurerm_network_manager_network_group.app_vnets.id
}

output "vnet_ids" {
  value = { for k, v in azurerm_virtual_network.this : k => v.id }
}
