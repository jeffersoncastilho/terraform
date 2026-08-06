variable "name" {
  type        = string
  description = "Nome do budget"
}

variable "subscription_id" {
  type        = string
  description = "GUID da subscription onde o budget será criado"
}

variable "amount" {
  type        = number
  description = "Valor do budget no ciclo definido por time_grain"
}

variable "time_grain" {
  type        = string
  description = "Periodicidade do budget (Monthly, Quarterly, Annually, BillingMonth, BillingQuarter, BillingAnnual)"
  default     = "Monthly"
}

variable "start_date" {
  type        = string
  description = "Início do período do budget, em RFC3339, deve ser o primeiro dia do mês (ex: 2026-08-01T00:00:00Z)"
}

variable "end_date" {
  type        = string
  description = "Fim do período do budget, em RFC3339 (opcional, padrão é 10 anos após start_date)"
  default     = null
}

variable "thresholds" {
  type        = list(number)
  description = "Percentuais de consumo que disparam alerta (ex: [50, 80, 100])"
  default     = [80, 100]
}

variable "contact_emails" {
  type        = list(string)
  description = "E-mails que recebem os alertas de threshold"
}
