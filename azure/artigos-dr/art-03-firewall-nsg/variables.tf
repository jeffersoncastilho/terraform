variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "sku" {
  description = "SKU do Azure Firewall e da Firewall Policy (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-03-firewall-nsg"
  }
}
