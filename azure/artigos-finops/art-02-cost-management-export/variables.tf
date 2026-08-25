variable "subscription_id" {
  type        = string
  description = "ID da subscription Azure"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Região principal do Azure"
  default     = "eastus"
}

variable "container_name" {
  type        = string
  description = "Nome do container de storage onde os exports são gravados"
  default     = "cost-exports"
}

variable "recurrence_type" {
  type        = string
  description = "Periodicidade do export"
  default     = "Monthly"
}

variable "start_date" {
  type        = string
  description = "Início do período do export, primeiro dia do mês em RFC3339"
}

variable "end_date" {
  type        = string
  description = "Fim do período do export, em RFC3339"
}
