variable "name" {
  description = "Nome do Network Security Group"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o NSG sera criado"
  type        = string
}

variable "location" {
  description = "Regiao Azure (ex: brazilsouth, eastus)"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet a associar com o NSG"
  type        = string
}

variable "security_rules" {
  description = "Lista de regras de seguranca do NSG"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
