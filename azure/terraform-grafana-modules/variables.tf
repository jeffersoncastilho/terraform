variable "name" {
  description = "Nome do Azure Managed Grafana"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Grafana será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Grafana"
  type        = string
}

variable "grafana_major_version" {
  description = "Versão principal do Grafana (9 ou 10)"
  type        = number
  default     = 10
}

variable "sku" {
  description = "SKU do Grafana Managed (Standard)"
  type        = string
  default     = "Standard"
}

variable "public_network_access_enabled" {
  description = "Habilitar acesso público ao endpoint do Grafana"
  type        = bool
  default     = true
}

variable "monitoring_scope" {
  description = "Escopo do role assignment Monitoring Reader (subscription ID ou resource group ID)"
  type        = string
}

variable "tags" {
  description = "Tags aplicadas ao Grafana"
  type        = map(string)
  default     = {}
}
