output "auth_rule_ids" {
  description = "IDs das Authorization Rules criadas para o tópico pedidos"
  value       = module.auth_pedidos.auth_rule_ids
}

output "consumer_group_names" {
  description = "Consumer Groups criados para a aplicação Python"
  value       = module.auth_pedidos.consumer_group_names
}
