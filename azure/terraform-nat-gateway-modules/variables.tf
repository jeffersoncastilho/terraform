variable "name" {
  description = "Nome do NAT Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o NAT Gateway será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do NAT Gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU do NAT Gateway (hoje só existe Standard)"
  type        = string
  default     = "Standard"
}

variable "idle_timeout_in_minutes" {
  description = "Timeout de conexões ociosas em minutos (4-120)"
  type        = number
  default     = 4
}

variable "public_ip_address_id" {
  description = "ID do Public IP associado ao NAT Gateway (ver terraform-public-ip-modules)"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets que passam a sair pela internet via este NAT Gateway"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
