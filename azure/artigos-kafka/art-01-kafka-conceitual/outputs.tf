output "resource_group_name" {
  description = "Nome do Resource Group da série Kafka"
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "ID do Resource Group da série Kafka"
  value       = module.resource_group.id
}

output "location" {
  description = "Região dos recursos da série"
  value       = module.resource_group.location
}
