variable "name" {
  description = "Nome do DDoS Protection Plan"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o plano será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do plano (não limita quais VNets/regiões ele pode proteger)"
  type        = string
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
