variable "name" {
  description = "Nome do Private Link Service"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Private Link Service será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Private Link Service"
  type        = string
}

variable "nat_subnet_id" {
  description = "ID da subnet dedicada para os IPs de NAT do Private Link Service (precisa ter private_link_service_network_policies_enabled = false)"
  type        = string
}

variable "load_balancer_frontend_ip_configuration_id" {
  description = "ID da configuração de frontend do Load Balancer interno exposto (ver terraform-load-balancer-modules)"
  type        = string
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
