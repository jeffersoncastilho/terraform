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
  description = "Resource Group que concentra VNets e o Network Manager"
  default     = "rg-blog-castilho-vnet-manager"
}

variable "vnets" {
  description = "VNets de exemplo gerenciadas pelo Network Manager (simulam times/apps distintos)"
  type = map(object({
    address_space = string
    subnet_prefix = string
  }))
  default = {
    frontend = {
      address_space = "10.20.1.0/24"
      subnet_prefix = "10.20.1.0/26"
    }
    backend = {
      address_space = "10.20.2.0/24"
      subnet_prefix = "10.20.2.0/26"
    }
    shared = {
      address_space = "10.20.3.0/24"
      subnet_prefix = "10.20.3.0/26"
    }
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "net-01-vnet-manager"
  }
}
