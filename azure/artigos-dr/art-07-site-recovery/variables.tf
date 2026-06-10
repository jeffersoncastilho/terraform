variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "recovery_point_retention_minutes" {
  description = "Retenção dos recovery points em minutos (ex: 1440 = 24h)"
  type        = number
  default     = 1440
}

variable "snapshot_frequency_minutes" {
  description = "Frequência de snapshots consistentes com a aplicação em minutos"
  type        = number
  default     = 240
}

variable "ssh_public_key" {
  description = "Chave pública SSH para acesso à VM (azureuser)."
  type        = string
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-07-site-recovery"
  }
}
