# Outputs de art-03-tag-governance-policy

output "policy_definition_id" {
  description = "ID da definição de policy criada"
  value       = module.tag_governance.policy_definition_id
}

output "policy_assignment_id" {
  description = "ID da atribuição de policy criada"
  value       = module.tag_governance.policy_assignment_id
}
