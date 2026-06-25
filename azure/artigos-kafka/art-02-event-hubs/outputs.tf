output "namespace_name" {
  description = "Nome do Event Hubs Namespace"
  value       = module.eventhub.namespace_name
}

output "namespace_id" {
  description = "ID do Event Hubs Namespace"
  value       = module.eventhub.namespace_id
}

output "namespace_fqdn" {
  description = "FQDN do endpoint Kafka (usar na configuração de produtores e consumidores)"
  value       = module.eventhub.namespace_fqdn
}

output "eventhub_ids" {
  description = "Mapa nome → ID de cada Event Hub criado"
  value       = module.eventhub.eventhub_ids
}
