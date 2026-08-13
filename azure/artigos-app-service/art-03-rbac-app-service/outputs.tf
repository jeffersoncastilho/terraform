# Outputs de art-03-rbac-app-service

output "role_definition_id" {
  description = "ID do custom role definition criado"
  value       = azurerm_role_definition.app_service_operator.role_definition_resource_id
}

output "role_definition_name" {
  description = "Nome do custom role definition"
  value       = azurerm_role_definition.app_service_operator.name
}
