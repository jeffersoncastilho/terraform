variable "subscription_id" {
  type        = string
  description = "ID da subscription Azure"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Região onde os recursos são criados"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group que concentra o Application Gateway e o backend de teste"
  default     = "rg-blog-castilho-appgw"
}

variable "vnet_address_space" {
  type    = string
  default = "10.40.0.0/16"
}

variable "appgw_subnet_prefix" {
  type    = string
  default = "10.40.1.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "net-02-appgw-waf"
  }
}
