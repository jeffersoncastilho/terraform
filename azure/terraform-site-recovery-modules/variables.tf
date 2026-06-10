variable "name" {
  description = "Nome do Recovery Services Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o RSV será criado (deve ser na região target)"
  type        = string
}

variable "location" {
  description = "Região Azure do RSV (região target/secundária)"
  type        = string
}

variable "sku" {
  description = "SKU do Recovery Services Vault (Standard, RS0)"
  type        = string
  default     = "Standard"
}

variable "source_location" {
  description = "Região de origem para replicação (ex: brazilsouth)"
  type        = string
}

variable "target_location" {
  description = "Região de destino para replicação (ex: eastus)"
  type        = string
}

variable "source_network_id" {
  description = "ID da VNet de origem para network mapping"
  type        = string
}

variable "target_network_id" {
  description = "ID da VNet de destino para network mapping"
  type        = string
}

variable "recovery_point_retention_minutes" {
  description = "Retenção dos recovery points em minutos (ex: 1440 = 24h)"
  type        = number
  default     = 1440
}

variable "snapshot_frequency_minutes" {
  description = "Frequência de snapshots consistentes com a aplicação em minutos"
  type        = number
  default     = 240
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
