variable "name" {
  description = "Nome do Azure Bastion Host"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Bastion será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Bastion"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet AzureBastionSubnet"
  type        = string
}

variable "sku" {
  description = "SKU do Bastion (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "scale_units" {
  description = "Número de scale units (2-50, apenas SKU Standard/Premium)"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
