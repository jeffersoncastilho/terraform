variable "name" {
  description = "Nome do Application Gateway"
  type        = string
}

variable "waf_policy_name" {
  description = "Nome da WAF Policy"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde os recursos serão criados"
  type        = string
}

variable "location" {
  description = "Região Azure"
  type        = string
}

variable "gateway_subnet_id" {
  description = "ID da subnet dedicada ao Application Gateway (não pode ter outro recurso)"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID do Public IP do frontend (ver terraform-public-ip-modules)"
  type        = string
}

variable "waf_mode" {
  description = "Prevention (bloqueia) ou Detection (só loga) — Prevention é o padrão recomendado em produção"
  type        = string
  default     = "Prevention"
}

variable "owasp_version" {
  description = "Versão do OWASP Core Rule Set"
  type        = string
  default     = "3.2"
}

variable "autoscale_min_capacity" {
  type    = number
  default = 0
}

variable "autoscale_max_capacity" {
  type    = number
  default = 2
}

variable "frontend_port" {
  description = "Porta do listener HTTP exposto ao cliente"
  type        = number
  default     = 80
}

variable "backend_fqdns" {
  description = "FQDNs do backend (ex: endpoint de um Storage Static Website) — use isto OU backend_ip_addresses, não os dois"
  type        = list(string)
  default     = null
}

variable "backend_ip_addresses" {
  description = "IPs do backend — use isto OU backend_fqdns, não os dois"
  type        = list(string)
  default     = null
}

variable "backend_port" {
  type    = number
  default = 443
}

variable "backend_protocol" {
  type    = string
  default = "Https"
}

variable "backend_request_timeout" {
  type    = number
  default = 30
}

variable "backend_pick_host_name" {
  description = "Usar o hostname do próprio backend no cabeçalho Host — necessário para backends por FQDN como Storage Static Website"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
