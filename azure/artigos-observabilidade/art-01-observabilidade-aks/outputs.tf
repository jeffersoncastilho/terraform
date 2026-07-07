output "resource_group_name" {
  description = "Resource Group criado para o lab de observabilidade"
  value       = module.resource_group.name
}

output "grafana_endpoint" {
  description = "URL de acesso ao Azure Managed Grafana"
  value       = module.grafana.endpoint
}

output "grafana_name" {
  description = "Nome do Azure Managed Grafana"
  value       = module.grafana.name
}

output "amw_query_endpoint" {
  description = "Endpoint de query PromQL do Azure Monitor Workspace"
  value       = module.monitor_workspace.query_endpoint
}

output "log_analytics_workspace_id" {
  description = "ID do Log Analytics Workspace"
  value       = module.log_analytics.workspace_id
}

output "appinsights_connection_string" {
  description = "Connection String do Application Insights (para a OpenTelemetry Distro)"
  value       = module.app_insights.connection_string
  sensitive   = true
}
