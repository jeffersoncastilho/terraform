variable "name" {
  description = "Nome do Traffic Manager Profile"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Traffic Manager será criado"
  type        = string
}

variable "routing_method" {
  description = "Método de roteamento (Priority, Weighted, Performance, Geographic, MultiValue, Subnet)"
  type        = string
  default     = "Priority"
}

variable "dns_relative_name" {
  description = "Prefixo DNS relativo do Traffic Manager (nome.trafficmanager.net)"
  type        = string
}

variable "ttl" {
  description = "TTL do registro DNS em segundos"
  type        = number
  default     = 30
}

variable "probe_protocol" {
  description = "Protocolo do health probe (HTTP, HTTPS, TCP)"
  type        = string
  default     = "HTTPS"
}

variable "probe_port" {
  description = "Porta do health probe"
  type        = number
  default     = 443
}

variable "probe_path" {
  description = "Path do health probe"
  type        = string
  default     = "/health"
}

variable "probe_interval_seconds" {
  description = "Intervalo entre probes em segundos"
  type        = number
  default     = 30
}

variable "probe_timeout_seconds" {
  description = "Timeout do probe em segundos"
  type        = number
  default     = 9
}

variable "probe_tolerated_failures" {
  description = "Número de falhas toleradas antes de marcar endpoint como unhealthy"
  type        = number
  default     = 3
}

variable "endpoints" {
  description = "Lista de endpoints externos do Traffic Manager"
  type = list(object({
    name     = string
    target   = string
    priority = number
    weight   = number
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
