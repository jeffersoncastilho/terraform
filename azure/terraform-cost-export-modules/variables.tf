variable "name" {
  type        = string
  description = "Nome do cost management export"
}

variable "subscription_id" {
  type        = string
  description = "GUID da subscription onde o export será criado"
}

variable "resource_group_name" {
  type        = string
  description = "Nome do resource group onde o storage account será criado"
}

variable "location" {
  type        = string
  description = "Região do resource group e storage account"
  default     = "eastus"
}

variable "storage_account_name" {
  type        = string
  description = "Nome do storage account (globalmente único, lowercase, 3-24 chars, sem hífen)"
}

variable "container_name" {
  type        = string
  description = "Nome do container onde os arquivos exportados serão gravados"
  default     = "cost-exports"
}

variable "root_folder_path" {
  type        = string
  description = "Caminho raiz dentro do container para os arquivos exportados"
  default     = "exports"
}

variable "recurrence_type" {
  type        = string
  description = "Periodicidade do export (Daily, Weekly, Monthly, Annually)"
  default     = "Monthly"
}

variable "start_date" {
  type        = string
  description = "Início do período do export, em RFC3339 (ex: 2026-08-01T00:00:00Z)"
}

variable "end_date" {
  type        = string
  description = "Fim do período do export, em RFC3339"
}

variable "export_type" {
  type        = string
  description = "Tipo de custo exportado (ActualCost, AmortizedCost, Usage — algumas subscriptions, como MPN, só aceitam Usage)"
  default     = "Usage"
}

variable "time_frame" {
  type        = string
  description = "Intervalo de tempo coberto por cada execução (MonthToDate, BillingMonthToDate, TheLastMonth, TheLastBillingMonth, WeekToDate)"
  default     = "MonthToDate"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas nos recursos que suportam tags (resource group e storage account — o export em si não suporta tags no provider azurerm)"
  default     = {}
}
