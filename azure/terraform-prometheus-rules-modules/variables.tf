variable "name" {
  description = "Nome do Prometheus Rule Group"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group do rule group"
  type        = string
}

variable "location" {
  description = "Região Azure"
  type        = string
}

variable "scopes" {
  description = "Lista de IDs de escopo (Azure Monitor Workspace)"
  type        = list(string)
}

variable "cluster_name" {
  description = "Nome do cluster AKS associado (opcional)"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Habilitar o rule group"
  type        = bool
  default     = true
}

variable "interval" {
  description = "Intervalo de avaliação das regras (ISO 8601, ex: PT1M)"
  type        = string
  default     = "PT1M"
}

variable "rules" {
  description = "Lista de regras de alerta Prometheus"
  type = list(object({
    alert       = string
    expression  = string
    for         = string
    severity    = number
    labels      = optional(map(string), {})
    annotations = optional(map(string), {})
  }))
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
