# Outputs de art-02-cost-management-export
# Padrão de naming: <workload>-blog-castilho

output "export_id" {
  description = "ID do cost management export criado"
  value       = module.cost_export.id
}

output "export_name" {
  description = "Nome do cost management export criado"
  value       = module.cost_export.name
}

output "storage_account_name" {
  description = "Nome do storage account criado para os exports"
  value       = module.cost_export.storage_account_name
}
