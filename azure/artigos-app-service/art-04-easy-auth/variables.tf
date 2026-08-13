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
    artigo     = "art-04-easy-auth"
  }
}

variable "aad_client_id" {
  type        = string
  description = "Application (client) ID do App Registration no Microsoft Entra ID usado pelo Easy Auth"
}

variable "aad_client_secret" {
  type        = string
  description = "Client secret do App Registration"
  sensitive   = true
}
