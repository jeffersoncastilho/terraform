variable "name" {
  description = "Nome do Azure Front Door Profile"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Front Door será criado"
  type        = string
}

variable "sku" {
  description = "SKU do Front Door (Standard_AzureFrontDoor, Premium_AzureFrontDoor)"
  type        = string
  default     = "Premium_AzureFrontDoor"
}

variable "waf_policy_name" {
  description = "Nome da WAF Policy (sem hífens — restrição Azure)"
  type        = string
}

variable "waf_mode" {
  description = "Modo da WAF (Detection, Prevention)"
  type        = string
  default     = "Prevention"
}

variable "endpoint_name" {
  description = "Nome do Front Door Endpoint"
  type        = string
}

variable "origin_group_name" {
  description = "Nome do Origin Group"
  type        = string
}

variable "route_name" {
  description = "Nome da Route"
  type        = string
}

variable "security_policy_name" {
  description = "Nome da Security Policy"
  type        = string
}

variable "origins" {
  description = "Lista de origins do Front Door"
  type = list(object({
    name      = string
    host_name = string
    priority  = number
    weight    = number
  }))
  default = []
}

variable "lb_sample_size" {
  description = "Número de amostras para load balancing"
  type        = number
  default     = 4
}

variable "lb_successful_samples" {
  description = "Amostras com sucesso necessárias"
  type        = number
  default     = 3
}

variable "lb_additional_latency_ms" {
  description = "Latência adicional em ms para load balancing"
  type        = number
  default     = 50
}

variable "probe_path" {
  description = "Path do health probe"
  type        = string
  default     = "/health"
}

variable "probe_protocol" {
  description = "Protocolo do health probe (Http, Https)"
  type        = string
  default     = "Https"
}

variable "probe_interval_seconds" {
  description = "Intervalo do health probe em segundos"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
