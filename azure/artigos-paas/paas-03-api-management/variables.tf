variable "subscription_id" {
  type        = string
  description = "ID da subscription Azure"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Região onde os recursos são criados"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group que concentra a instância do API Management"
  default     = "rg-blog-castilho-apim"
}

variable "publisher_name" {
  type    = string
  default = "Jefferson Castilho"
}

variable "publisher_email" {
  type        = string
  description = "E-mail do publisher exigido pelo APIM — usar um e-mail real de contato"
  default     = "contato@jeffersoncastilho.com.br"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "paas-03-api-management"
  }
}
