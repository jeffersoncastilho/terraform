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

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas em todos os recursos"
  default     = {}
}

variable "amount" {
  type        = number
  description = "Valor mensal do budget"
  default     = 20
}

variable "thresholds" {
  type        = list(number)
  description = "Percentuais de consumo que disparam alerta"
  default     = [50, 80, 100]
}

variable "contact_emails" {
  type        = list(string)
  description = "E-mails que recebem os alertas de threshold"
  default     = ["jefferson.castilho@outlook.com"]
}

variable "start_date" {
  type        = string
  description = "Início do período do budget, primeiro dia do mês em RFC3339"
}
