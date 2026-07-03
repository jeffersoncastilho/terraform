output "grafana_name" {
  description = "Nome do Azure Managed Grafana"
  value       = module.grafana.name
}

output "grafana_id" {
  description = "ID do Azure Managed Grafana"
  value       = module.grafana.id
}

output "grafana_endpoint" {
  description = "URL de acesso ao Grafana"
  value       = module.grafana.endpoint
}

output "log_analytics_workspace_name" {
  description = "Nome do Log Analytics Workspace"
  value       = module.log_analytics.workspace_name
}

output "log_analytics_workspace_id" {
  description = "ID do Log Analytics Workspace"
  value       = module.log_analytics.workspace_id
}
