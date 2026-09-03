output "nat_gateway_public_ip" {
  value = azurerm_public_ip.natgw.ip_address
}

output "container_group_name" {
  value = azurerm_container_group.test.name
}
