variable "name" {
  description = "Nome do Azure Monitor Workspace (armazena métricas Prometheus)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o workspace será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do workspace"
  type        = string
}

variable "create_dcr" {
  description = "Criar Data Collection Endpoint e Rule para scrape de Prometheus"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
