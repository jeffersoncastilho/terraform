variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    serie      = "kafka-no-azure"
    artigo     = "art-01"
    managed-by = "terraform"
  }
}
