variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "role_name" {
  description = "Nome da IAM role assumida pelos pods"
  type        = string
}

variable "service_accounts" {
  description = "Service accounts (namespace + nome) que recebem a role"
  type = list(object({
    namespace = string
    name      = string
  }))
}

variable "policy_arns" {
  description = "Políticas gerenciadas anexadas à role"
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Política inline (JSON) com o mínimo necessário; null = nenhuma"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
