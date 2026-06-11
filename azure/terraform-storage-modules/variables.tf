variable "name" {
  description = "Nome do Storage Account (somente alfanumérico minúsculo, 3-24 chars)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Storage Account será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Storage Account"
  type        = string
}

variable "account_tier" {
  description = "Tier do Storage Account (Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Tipo de replicação (LRS, ZRS, GRS, GZRS, RA-GRS, RA-GZRS, RAGZRS)"
  type        = string
  default     = "LRS"
}

variable "public_network_access_enabled" {
  description = "Habilitar acesso público à rede"
  type        = bool
  default     = true
}

variable "containers" {
  description = "Lista de nomes de containers a criar"
  type        = list(string)
  default     = []
}

variable "private_endpoints" {
  description = "Lista de private endpoints para o storage account"
  type = list(object({
    name                 = string
    resource_group_name  = string
    location             = string
    subnet_id            = string
    subresource          = string
    private_dns_zone_ids = optional(list(string))
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
