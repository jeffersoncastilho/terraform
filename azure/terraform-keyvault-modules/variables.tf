variable "name" {
  description = "Nome do Key Vault (3-24 chars, globalmente único)."
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group onde o Key Vault será criado."
  type        = string
}

variable "location" {
  description = "Região do Azure."
  type        = string
}

variable "tenant_id" {
  description = "ID do tenant Azure AD."
  type        = string
}

variable "sku_name" {
  description = "SKU do Key Vault: 'standard' ou 'premium'."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Dias de retenção para soft delete (7-90)."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Habilita proteção contra purge (não pode ser desabilitado depois)."
  type        = bool
  default     = false
}

variable "network_acls_bypass" {
  description = "Serviços que podem bypassar as regras de rede: 'AzureServices' ou 'None'."
  type        = string
  default     = "AzureServices"
}

variable "network_acls_default_action" {
  description = "Ação padrão para tráfego não correspondido: 'Allow' ou 'Deny'."
  type        = string
  default     = "Allow"
}

variable "tags" {
  description = "Tags aplicadas ao Key Vault."
  type        = map(string)
  default     = {}
}
