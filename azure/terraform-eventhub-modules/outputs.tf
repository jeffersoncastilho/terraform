output "namespace_id" {
  description = "ID do Event Hubs Namespace"
  value       = azurerm_eventhub_namespace.this.id
}

output "namespace_name" {
  description = "Nome do Event Hubs Namespace"
  value       = azurerm_eventhub_namespace.this.name
}

output "namespace_fqdn" {
  description = "FQDN do endpoint Kafka (host:9093)"
  value       = "${azurerm_eventhub_namespace.this.name}.servicebus.windows.net"
}

output "eventhub_ids" {
  description = "Mapa nome → ID de cada Event Hub criado"
  value       = { for k, v in azurerm_eventhub.this : k => v.id }
}
