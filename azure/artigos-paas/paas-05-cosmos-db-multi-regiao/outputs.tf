output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.this.endpoint
}

output "write_endpoints" {
  value = azurerm_cosmosdb_account.this.write_endpoints
}
