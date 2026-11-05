variable "name" {
  description = "Nome da Function App (globalmente único)"
  type        = string
}

variable "plan_name" {
  description = "Nome do App Service Plan"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde os recursos serão criados"
  type        = string
}

variable "location" {
  description = "Região Azure"
  type        = string
}

variable "sku_name" {
  description = "Ex: Y1 (Consumption), EP1/EP2/EP3 (Elastic Premium, exigido para integração de VNet regional)"
  type        = string
  default     = "EP1"
}

variable "storage_account_name" {
  description = "Nome do Storage Account obrigatório para qualquer Function App"
  type        = string
}

variable "storage_account_access_key" {
  type      = string
  sensitive = true
}

variable "subnet_id" {
  description = "Subnet delegada a Microsoft.Web/serverFarms para integração de VNet regional — null (padrão) não integra a nenhuma VNet (exige plano Elastic Premium ou Dedicated, não Consumption)"
  type        = string
  default     = null
}

variable "node_version" {
  type    = string
  default = "20"
}

variable "app_settings" {
  description = "App settings adicionais além do WEBSITE_VNET_ROUTE_ALL automático"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags aplicadas aos recursos"
  type        = map(string)
  default     = {}
}
