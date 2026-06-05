variable "name" {
  description = "Nome da Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group onde a VNet será criada"
  type        = string
}

variable "location" {
  description = "Região Azure (ex: brazilsouth, eastus)"
  type        = string
}

variable "address_space" {
  description = "Lista de blocos CIDR da VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Lista de subnets a criar na VNet"
  type = list(object({
    key              = string
    name             = string
    address_prefixes = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas à VNet"
  type        = map(string)
  default     = {}
}
