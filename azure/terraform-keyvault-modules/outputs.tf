output "key_vault_id" {
  description = "ID do Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Nome do Key Vault"
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "URI do Key Vault (https://<name>.vault.azure.net/)"
  value       = azurerm_key_vault.this.vault_uri
}
