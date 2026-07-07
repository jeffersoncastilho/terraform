variable "name" {
  description = "Nome do Log Analytics Workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o workspace será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do workspace"
  type        = string
}

variable "sku" {
  description = "SKU do Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retenção de dados em dias (30-730)"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
