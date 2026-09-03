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
  description = "Resource Group que concentra a Function App, o plano Premium e a VNet"
  default     = "rg-blog-castilho-functions"
}

variable "vnet_address_space" {
  type    = string
  default = "10.100.0.0/16"
}

variable "functions_subnet_prefix" {
  type    = string
  default = "10.100.1.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "paas-01-functions-premium-vnet"
  }
}
