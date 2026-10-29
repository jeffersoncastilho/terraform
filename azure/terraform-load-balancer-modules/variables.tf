variable "name" {
  description = "Nome do Load Balancer"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Load Balancer será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Load Balancer"
  type        = string
}

variable "sku" {
  description = "SKU do Load Balancer (Basic ou Standard)"
  type        = string
  default     = "Standard"
}

variable "frontend_name" {
  description = "Nome da configuração de frontend"
  type        = string
  default     = "frontend-internal"
}

variable "frontend_subnet_id" {
  description = "ID da subnet do frontend interno (Load Balancer interno, sem IP público)"
  type        = string
}

variable "protocol" {
  description = "Protocolo da regra/probe (Tcp, Udp ou Http)"
  type        = string
  default     = "Tcp"
}

variable "port" {
  description = "Porta usada pela regra e pelo probe (mesma porta no frontend e backend)"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
