variable "scope" {
  description = "Escopo do role assignment (ID da subscription, resource group ou recurso)."
  type        = string
}

variable "role_definition_name" {
  description = "Nome do papel Azure RBAC (ex: 'Contributor', 'Key Vault Secrets User', 'Storage Blob Data Contributor')."
  type        = string
}

variable "principal_id" {
  description = "Object ID do principal (usuário, grupo, service principal ou managed identity)."
  type        = string
}

variable "skip_service_principal_aad_check" {
  description = "Pular verificação AAD para Service Principals ou Managed Identities recém-criados (evita race condition)."
  type        = bool
  default     = false
}
