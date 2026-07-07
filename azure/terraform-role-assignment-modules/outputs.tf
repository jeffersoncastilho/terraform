output "id" {
  description = "ID do role assignment."
  value       = azurerm_role_assignment.this.id
}

output "role_definition_id" {
  description = "ID da role definition atribuída."
  value       = azurerm_role_assignment.this.role_definition_id
}

output "principal_id" {
  description = "Principal ID ao qual o papel foi atribuído."
  value       = azurerm_role_assignment.this.principal_id
}
