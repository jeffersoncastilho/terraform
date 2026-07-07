variable "name" {
  description = "Nome do Application Insights"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Application Insights será criado"
  type        = string
}

variable "location" {
  description = "Região Azure"
  type        = string
}

variable "workspace_id" {
  description = "ID do Log Analytics Workspace (Application Insights workspace-based)"
  type        = string
}

variable "application_type" {
  description = "Tipo da aplicação (web, java, Node.JS, etc.)"
  type        = string
  default     = "web"
}

variable "sampling_percentage" {
  description = "Percentual de amostragem de telemetria (0-100). null = padrão do serviço"
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
