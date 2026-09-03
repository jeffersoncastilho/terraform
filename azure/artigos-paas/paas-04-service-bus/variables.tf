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
  description = "Resource Group que concentra o namespace do Service Bus"
  default     = "rg-blog-castilho-servicebus"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "paas-04-service-bus"
  }
}
