output "schema_group_ids" {
  description = "Mapa nome → ID de cada Schema Group criado"
  value       = module.schema_registry.schema_group_ids
}

output "schema_group_names" {
  description = "Nomes dos Schema Groups criados"
  value       = module.schema_registry.schema_group_names
}
