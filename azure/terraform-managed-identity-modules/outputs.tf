output "id" {
  description = "ID do recurso da Managed Identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "name" {
  description = "Nome da Managed Identity."
  value       = azurerm_user_assigned_identity.this.name
}

output "principal_id" {
  description = "Object ID do Service Principal associado à identidade (usado em role assignments)."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client ID (Application ID) da identidade."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "tenant_id" {
  description = "Tenant ID associado à identidade."
  value       = azurerm_user_assigned_identity.this.tenant_id
}
