output "flow_log_id" {
  value = azurerm_network_watcher_flow_log.this.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.netwatcher.id
}
