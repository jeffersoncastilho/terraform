# Outputs de art-02-managed-identity
# Padrão de naming: <workload>-blog-castilho-eus

output "identity_id" {
  description = "ID do recurso da Managed Identity"
  value       = module.identity.id
}

output "identity_client_id" {
  description = "Client ID da Managed Identity (usado no az webapp identity assign)"
  value       = module.identity.client_id
}

output "identity_principal_id" {
  description = "Object ID da Managed Identity (usado em role assignments)"
  value       = module.identity.principal_id
}

output "key_vault_name" {
  description = "Nome do Key Vault criado"
  value       = module.keyvault.key_vault_name
}

output "key_vault_uri" {
  description = "URI do Key Vault (https://<name>.vault.azure.net/)"
  value       = module.keyvault.vault_uri
}
