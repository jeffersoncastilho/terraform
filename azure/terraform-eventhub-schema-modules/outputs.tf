output "schema_group_ids" {
  description = "Mapa nome → ID de cada Schema Group criado"
  value       = { for k, v in azurerm_eventhub_namespace_schema_group.this : k => v.id }
}

output "schema_group_names" {
  description = "Lista de nomes dos Schema Groups criados"
  value       = [for sg in azurerm_eventhub_namespace_schema_group.this : sg.name]
}
