variable "subscription_id" {
  type        = string
  description = "ID da subscription Azure"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Região principal do Azure"
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas em todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-14-multi-container-compose"
  }
}
