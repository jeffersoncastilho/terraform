variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "retention_days" {
  description = "Retenção de logs nos workspaces em dias"
  type        = number
  default     = 90
}

variable "alert_email" {
  description = "E-mail para receber alertas críticos e de aviso"
  type        = string
}

variable "teams_webhook_uri" {
  description = "Webhook do canal Teams para notificações (deixe em branco para desabilitar)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-13-monitoramento"
  }
}
