output "storage_account_id" {
  description = "ID do Storage Account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Nome do Storage Account"
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Endpoint primário do Blob Storage"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_access_key" {
  description = "Chave de acesso primária"
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}
