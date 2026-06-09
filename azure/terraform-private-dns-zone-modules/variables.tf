variable "zone_name" {
  description = "Nome da Private DNS Zone (ex: privatelink.blob.core.windows.net)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde a zona será criada"
  type        = string
}

variable "vnet_links" {
  description = "Map de chave => vnet_id para criar os Virtual Network Links"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
