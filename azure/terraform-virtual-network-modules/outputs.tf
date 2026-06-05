output "vnet_id" {
  description = "ID da Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nome da Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "resource_group_name" {
  description = "Nome do Resource Group da VNet"
  value       = azurerm_virtual_network.this.resource_group_name
}

output "subnets" {
  description = "Map das subnets criadas"
  value       = azurerm_subnet.this
}
