output "id" {
  description = "ID do cost management export criado"
  value       = azurerm_subscription_cost_management_export.this.id
}

output "name" {
  description = "Nome do cost management export criado"
  value       = azurerm_subscription_cost_management_export.this.name
}

output "storage_account_name" {
  description = "Nome do storage account criado para os exports"
  value       = azurerm_storage_account.this.name
}

output "container_name" {
  description = "Nome do container onde os exports são gravados"
  value       = azurerm_storage_container.this.name
}
