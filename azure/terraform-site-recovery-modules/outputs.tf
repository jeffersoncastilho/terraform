output "vault_id" {
  description = "ID do Recovery Services Vault"
  value       = azurerm_recovery_services_vault.this.id
}

output "vault_name" {
  description = "Nome do Recovery Services Vault"
  value       = azurerm_recovery_services_vault.this.name
}

output "replication_policy_id" {
  description = "ID da Replication Policy"
  value       = azurerm_site_recovery_replication_policy.this.id
}
