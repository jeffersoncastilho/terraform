variable "subscription_id" {
  type        = string
  description = "ID da subscription Azure"
  sensitive   = true
}

variable "primary_location" {
  type    = string
  default = "eastus"
}

variable "secondary_location" {
  type    = string
  default = "westus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group que concentra os dois SQL Servers e o Failover Group"
  default     = "rg-blog-castilho-sql-ha"
}

variable "sql_admin_login" {
  type    = string
  default = "sqladminblog"
}

variable "sql_admin_password" {
  type        = string
  description = "Senha do admin do SQL Server — usar TF_VAR_sql_admin_password ou .tfvars fora do Git, nunca hardcoded"
  sensitive   = true
  default     = "changeme-use-tfvars-ou-tf-var-env-CH4NG3!"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "paas-07-sql-failover-groups"
  }
}
