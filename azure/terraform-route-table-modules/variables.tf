variable "name" {
  description = "Nome da Route Table"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde a Route Table sera criada"
  type        = string
}

variable "location" {
  description = "Regiao Azure (ex: brazilsouth, eastus)"
  type        = string
}

variable "bgp_route_propagation_enabled" {
  description = "Habilitar propagacao de rotas BGP"
  type        = bool
  default     = false
}

variable "routes" {
  description = "Lista de rotas da Route Table"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = []
}

variable "subnet_ids" {
  description = "IDs das subnets a associar com a Route Table"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
