variable "name" {
  description = "Nome do Public IP"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Public IP será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Public IP"
  type        = string
}

variable "allocation_method" {
  description = "Método de alocação (Static ou Dynamic) — recursos como Gateway/App Gateway/NAT Gateway exigem Static"
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "SKU do Public IP (Basic ou Standard) — Standard é obrigatório para NAT Gateway, App Gateway v2 e a maioria dos gateways atuais"
  type        = string
  default     = "Standard"
}

variable "zones" {
  description = "Zonas de disponibilidade do IP (opcional)"
  type        = list(string)
  default     = null
}

variable "ddos_protection_mode" {
  description = "VirtualNetworkInherited (padrão do Azure, deixe null), Enabled ou Disabled — controla a telemetria de DDoS por IP em vez de por VNet inteira"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags aplicadas ao Public IP"
  type        = map(string)
  default     = {}
}
