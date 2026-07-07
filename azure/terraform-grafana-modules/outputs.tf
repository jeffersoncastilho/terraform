output "id" {
  description = "ID do Azure Managed Grafana"
  value       = azurerm_dashboard_grafana.this.id
}

output "name" {
  description = "Nome do Azure Managed Grafana"
  value       = azurerm_dashboard_grafana.this.name
}

output "endpoint" {
  description = "URL do endpoint do Grafana"
  value       = azurerm_dashboard_grafana.this.endpoint
}

output "principal_id" {
  description = "Principal ID da Managed Identity do Grafana"
  value       = azurerm_dashboard_grafana.this.identity[0].principal_id
}
