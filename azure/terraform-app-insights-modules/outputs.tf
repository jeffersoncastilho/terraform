output "id" {
  description = "ID do Application Insights"
  value       = azurerm_application_insights.this.id
}

output "name" {
  description = "Nome do Application Insights"
  value       = azurerm_application_insights.this.name
}

output "connection_string" {
  description = "Connection String para a Azure Monitor OpenTelemetry Distro"
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}

output "instrumentation_key" {
  description = "Instrumentation Key (legado — prefira a connection string)"
  value       = azurerm_application_insights.this.instrumentation_key
  sensitive   = true
}

output "app_id" {
  description = "App ID do Application Insights"
  value       = azurerm_application_insights.this.app_id
}
