output "id" {
  description = "ID do budget criado"
  value       = azurerm_consumption_budget_subscription.this.id
}

output "name" {
  description = "Nome do budget criado"
  value       = azurerm_consumption_budget_subscription.this.name
}
