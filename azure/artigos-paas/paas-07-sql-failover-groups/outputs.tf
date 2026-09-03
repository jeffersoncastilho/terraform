output "failover_group_listener_endpoint" {
  value = azurerm_mssql_failover_group.this.name
}

output "primary_server_fqdn" {
  value = azurerm_mssql_server.primary.fully_qualified_domain_name
}
