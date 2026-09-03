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
  description = "Resource Group que concentra a conta do Cosmos DB"
  default     = "rg-blog-castilho-cosmosdb"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "paas-05-cosmos-db-multi-regiao"
  }
}
