output "automation_account_id" {
  description = "ID do Automation Account"
  value       = azurerm_automation_account.this.id
}

output "automation_account_name" {
  description = "Nome do Automation Account"
  value       = azurerm_automation_account.this.name
}

output "runbook_id" {
  description = "ID do Runbook"
  value       = azurerm_automation_runbook.this.id
}

output "webhook_uri" {
  description = "URI do Webhook (visível apenas na criação)"
  value       = var.create_webhook ? azurerm_automation_webhook.this[0].uri : null
  sensitive   = true
}

output "principal_id" {
  description = "Principal ID da System Managed Identity do Automation Account"
  value       = azurerm_automation_account.this.identity[0].principal_id
}
