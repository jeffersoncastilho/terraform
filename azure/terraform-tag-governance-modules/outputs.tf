output "policy_definition_id" {
  description = "ID da definição de policy criada"
  value       = azurerm_policy_definition.tag_governance.id
}

output "policy_assignment_id" {
  description = "ID da atribuição de policy criada"
  value       = azurerm_subscription_policy_assignment.tag_governance.id
}

output "principal_id" {
  description = "Principal ID da managed identity da atribuição"
  value       = azurerm_subscription_policy_assignment.tag_governance.identity[0].principal_id
}
