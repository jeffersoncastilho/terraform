output "id" {
  description = "ID do Prometheus Rule Group"
  value       = azurerm_monitor_alert_prometheus_rule_group.this.id
}

output "name" {
  description = "Nome do Prometheus Rule Group"
  value       = azurerm_monitor_alert_prometheus_rule_group.this.name
}
