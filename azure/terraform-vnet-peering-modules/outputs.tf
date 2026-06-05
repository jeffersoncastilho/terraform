output "peering_a_to_b_id" {
  description = "ID do peering A → B"
  value       = azurerm_virtual_network_peering.a_to_b.id
}

output "peering_b_to_a_id" {
  description = "ID do peering B → A"
  value       = azurerm_virtual_network_peering.b_to_a.id
}
