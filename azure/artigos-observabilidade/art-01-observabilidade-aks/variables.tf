variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Região Azure para os recursos de observabilidade"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    serie      = "observabilidade-azure"
    artigo     = "art-01"
    managed-by = "terraform"
  }
}
