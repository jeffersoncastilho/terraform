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
  description = "Resource Group que concentra a VNet, NSG, storage e workspace de log"
  default     = "rg-blog-castilho-netwatcher"
}

variable "vnet_address_space" {
  type    = string
  default = "10.80.0.0/16"
}

variable "subnet_prefix" {
  type    = string
  default = "10.80.1.0/24"
}

variable "flow_log_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "net-06-network-watcher"
  }
}
