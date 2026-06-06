output "route_table_id" {
  description = "ID da Route Table"
  value       = azurerm_route_table.this.id
}

output "route_table_name" {
  description = "Nome da Route Table"
  value       = azurerm_route_table.this.name
}
