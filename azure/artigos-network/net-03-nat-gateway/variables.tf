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
  description = "Resource Group que concentra a VNet, o NAT Gateway e o container de teste"
  default     = "rg-blog-castilho-natgw"
}

variable "vnet_address_space" {
  type    = string
  default = "10.50.0.0/16"
}

variable "subnet_prefix" {
  type    = string
  default = "10.50.1.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "net-03-nat-gateway"
  }
}
