output "acr_name" {
  description = "Nome do Azure Container Registry"
  value       = module.acr.registry_name
}

output "acr_login_server" {
  description = "Login server do ACR (usar como prefixo nas imagens)"
  value       = module.acr.login_server
}

output "container_group_name" {
  description = "Nome do Container Group do Kafka Connect"
  value       = module.kafka_connect.name
}

output "container_group_id" {
  description = "ID do Container Group do Kafka Connect"
  value       = module.kafka_connect.id
}

output "rest_endpoint" {
  description = "Endpoint REST do Kafka Connect (porta 8083)"
  value       = "http://${module.kafka_connect.ip_address}:8083"
}
