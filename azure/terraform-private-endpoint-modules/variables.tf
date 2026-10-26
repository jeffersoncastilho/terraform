variable "name" {
  description = "Nome do Private Endpoint"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Private Endpoint será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Private Endpoint"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde o Private Endpoint recebe seu IP privado (precisa ter private_endpoint_network_policies = Disabled)"
  type        = string
}

variable "private_connection_resource_id" {
  description = "ID do recurso consumido (Storage Account, SQL Server, Private Link Service, etc.)"
  type        = string
}

variable "subresource_names" {
  description = "Sub-recurso alvo (ex: [\"blob\"], [\"sqlServer\"]) — deixe null para Private Link Service, que não usa sub-recurso"
  type        = list(string)
  default     = null
}

variable "is_manual_connection" {
  description = "Se a conexão precisa de aprovação manual do lado do provedor"
  type        = bool
  default     = false
}

variable "private_dns_zone_ids" {
  description = "IDs das Private DNS Zones para registro automático (opcional)"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
