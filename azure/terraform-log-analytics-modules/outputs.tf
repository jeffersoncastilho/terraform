output "workspace_id" {
  description = "ID de recurso ARM do Log Analytics Workspace (para usar em scopes/diagnostic settings). Não confundir com o customer_id (GUID do workspace) — ver output customer_id."
  value       = azurerm_log_analytics_workspace.this.id
}

output "customer_id" {
  description = "Customer ID (GUID) do workspace — o atributo workspace_id do próprio recurso Azure, usado por integrações como Traffic Analytics que exigem o GUID em vez do resource ID ARM"
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "workspace_name" {
  description = "Nome do Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.name
}

output "primary_shared_key" {
  description = "Chave primária do workspace"
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}
