variable "name" {
  description = "Nome do ExpressRoute Circuit"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o circuito será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do circuito"
  type        = string
}

variable "service_provider_name" {
  description = "Nome do provedor de conectividade (precisa constar na lista de provedores do Azure na região)"
  type        = string
}

variable "peering_location" {
  description = "Local de peering físico do provedor (ex: 'Washington DC', 'Silicon Valley')"
  type        = string
}

variable "bandwidth_in_mbps" {
  description = "Largura de banda do circuito em Mbps"
  type        = number
  default     = 50
}

variable "sku_tier" {
  description = "Tier do SKU (Standard, Premium ou Local)"
  type        = string
  default     = "Standard"
}

variable "sku_family" {
  description = "Modelo de cobrança (MeteredData ou UnlimitedData)"
  type        = string
  default     = "MeteredData"
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
