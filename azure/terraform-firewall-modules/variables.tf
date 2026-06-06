variable "name" {
  description = "Nome do Azure Firewall (ex: afw-blog-castilho-brazilsouth)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Firewall sera criado"
  type        = string
}

variable "location" {
  description = "Regiao Azure (ex: brazilsouth, eastus)"
  type        = string
}

variable "subnet_id" {
  description = "ID da AzureFirewallSubnet da Hub VNet"
  type        = string
}

variable "sku" {
  description = "SKU do Firewall e da Firewall Policy (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
