variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "sku" {
  description = "SKU do Azure Bastion (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "scale_units" {
  description = "Número de scale units do Bastion (2-50)"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-04-bastion"
  }
}
