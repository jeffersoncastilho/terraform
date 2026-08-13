output "auth_rule_ids" {
  description = "Mapa nome → ID de cada Authorization Rule criada"
  value       = { for k, v in azurerm_eventhub_authorization_rule.this : k => v.id }
}

output "consumer_group_names" {
  description = "Lista de nomes dos Consumer Groups criados"
  value       = [for cg in azurerm_eventhub_consumer_group.this : cg.name]
}
