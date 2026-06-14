variable "name" {
  description = "Nome do Automation Account"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Automation Account será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Automation Account"
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID para atribuição da role Contributor"
  type        = string
  sensitive   = true
}

variable "sku" {
  description = "SKU do Automation Account (Basic, Free)"
  type        = string
  default     = "Basic"
}

variable "runbook_name" {
  description = "Nome do runbook principal"
  type        = string
}

variable "runbook_type" {
  description = "Tipo do runbook (PowerShell, PowerShell72, Python3, Script, GraphPowerShell)"
  type        = string
  default     = "PowerShell"
}

variable "runbook_content" {
  description = "Conteúdo do runbook (use file() no caller)"
  type        = string
}

variable "create_webhook" {
  description = "Criar webhook para o runbook"
  type        = bool
  default     = true
}

variable "webhook_expiry_time" {
  description = "Data de expiração do webhook (RFC3339, ex: 2027-12-31T00:00:00Z)"
  type        = string
  default     = "2027-12-31T00:00:00Z"
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
