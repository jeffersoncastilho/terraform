output "id" {
  description = "ID do Azure Monitor Workspace"
  value       = azurerm_monitor_workspace.this.id
}

output "name" {
  description = "Nome do Azure Monitor Workspace"
  value       = azurerm_monitor_workspace.this.name
}

output "query_endpoint" {
  description = "Endpoint de query PromQL do workspace"
  value       = azurerm_monitor_workspace.this.query_endpoint
}

output "dce_id" {
  description = "ID do Data Collection Endpoint (null se create_dcr = false)"
  value       = try(azurerm_monitor_data_collection_endpoint.this[0].id, null)
}

output "dcr_id" {
  description = "ID do Data Collection Rule (null se create_dcr = false)"
  value       = try(azurerm_monitor_data_collection_rule.this[0].id, null)
}
