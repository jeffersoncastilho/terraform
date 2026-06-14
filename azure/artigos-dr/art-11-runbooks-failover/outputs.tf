output "automation_account_id" {
  description = "ID do Automation Account"
  value       = module.automation.automation_account_id
}

output "automation_account_name" {
  description = "Nome do Automation Account"
  value       = module.automation.automation_account_name
}

output "runbook_id" {
  description = "ID do Runbook de failover"
  value       = module.automation.runbook_id
}

output "key_vault_id" {
  description = "ID do Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI do Key Vault"
  value       = module.key_vault.vault_uri
}
