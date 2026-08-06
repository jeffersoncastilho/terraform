# Outputs de art-01-budget-cost-management
# Padrão de naming: <workload>-blog-castilho

output "budget_id" {
  description = "ID do budget criado"
  value       = module.budget.id
}

output "budget_name" {
  description = "Nome do budget criado"
  value       = module.budget.name
}
