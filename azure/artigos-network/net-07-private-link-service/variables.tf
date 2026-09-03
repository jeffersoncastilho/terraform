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
  description = "Resource Group que concentra as duas VNets (provedora e consumidora) e o Private Link Service"
  default     = "rg-blog-castilho-pls"
}

variable "provider_vnet_address_space" {
  type    = string
  default = "10.90.0.0/16"
}

variable "provider_subnet_prefix" {
  type    = string
  default = "10.90.1.0/24"
}

# A subnet do Private Link Service (NAT subnet) precisa ser dedicada
variable "pls_nat_subnet_prefix" {
  type    = string
  default = "10.90.2.0/24"
}

variable "consumer_vnet_address_space" {
  type    = string
  default = "10.91.0.0/16"
}

variable "consumer_subnet_prefix" {
  type    = string
  default = "10.91.1.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "net-07-private-link-service"
  }
}
