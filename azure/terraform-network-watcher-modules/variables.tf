variable "name" {
  description = "Nome do Flow Log"
  type        = string
}

variable "location" {
  description = "Região Azure — usada para montar o nome do Network Watcher auto-criado (NetworkWatcher_<região>)"
  type        = string
}

variable "target_resource_id" {
  description = "ID da VNet alvo do Flow Log (VNet Flow Log — não usar NSG, descontinuado desde 30/06/2025)"
  type        = string
}

variable "storage_account_id" {
  description = "ID do Storage Account que recebe os logs brutos"
  type        = string
}

variable "retention_days" {
  description = "Retenção dos logs brutos em dias"
  type        = number
  default     = 7
}

variable "traffic_analytics_workspace_id" {
  description = "workspace_id do Log Analytics Workspace — null desativa o Traffic Analytics (só grava logs brutos)"
  type        = string
  default     = null
}

variable "traffic_analytics_workspace_region" {
  description = "Região do Log Analytics Workspace (obrigatório se traffic_analytics_workspace_id for informado)"
  type        = string
  default     = null
}

variable "traffic_analytics_workspace_resource_id" {
  description = "Resource ID do Log Analytics Workspace (obrigatório se traffic_analytics_workspace_id for informado)"
  type        = string
  default     = null
}

variable "traffic_analytics_interval_minutes" {
  description = "Intervalo de processamento do Traffic Analytics em minutos (10 ou 60)"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags aplicadas ao recurso"
  type        = map(string)
  default     = {}
}
