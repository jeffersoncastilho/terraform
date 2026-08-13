# Outputs de art-01-planejamento
# Padrão de naming: <workload>-blog-castilho-brs

output "resource_group_name" {
  description = "Nome do Resource Group criado"
  value       = module.rg.name
}

output "app_service_plan_id" {
  description = "ID do App Service Plan base"
  value       = module.appservice.plan_id
}

output "app_name" {
  description = "Nome do Web App base"
  value       = module.appservice.app_name
}

output "default_hostname" {
  description = "Hostname público do Web App base (*.azurewebsites.net)"
  value       = module.appservice.default_hostname
}
