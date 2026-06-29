variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "dockerhub_username" {
  description = "Username do Docker Hub para pull autenticado (evita rate limit no az acr import)"
  type        = string
  sensitive   = true
}

variable "dockerhub_password" {
  description = "Access token do Docker Hub (read-only)"
  type        = string
  sensitive   = true
}

variable "kafka_connect_sasl_password" {
  description = "Connection string do Event Hubs usada pelo Kafka Connect (SASL password)"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    serie      = "kafka-no-azure"
    artigo     = "art-04"
    managed-by = "terraform"
  }
}
