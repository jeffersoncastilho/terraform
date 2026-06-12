variable "name" {
  description = "Nome do Container Registry (somente alfanumérico, 5-50 chars)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o ACR será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do ACR"
  type        = string
}

variable "sku" {
  description = "SKU do ACR (Basic, Standard, Premium)"
  type        = string
  default     = "Premium"
}

variable "admin_enabled" {
  description = "Habilitar acesso via admin user (não recomendado em produção)"
  type        = bool
  default     = false
}

variable "geo_replication_locations" {
  description = "Regiões para geo-replicação do ACR (apenas Premium)"
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
