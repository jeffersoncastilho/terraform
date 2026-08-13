variable "namespace_name" {
  description = "Nome do Event Hubs Namespace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o namespace será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do namespace"
  type        = string
}

variable "sku" {
  description = "SKU do namespace (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "Número de Throughput Units (Standard) ou Processing Units (Premium)"
  type        = number
  default     = 2
}

variable "event_hubs" {
  description = "Lista de Event Hubs a criar dentro do namespace"
  type = list(object({
    name              = string
    partition_count   = number
    message_retention = number
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
