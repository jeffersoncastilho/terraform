variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "primary_replication_type" {
  description = "Tipo de replicação do Storage Account primário (RAGZRS para geo-replicação com RA)"
  type        = string
  default     = "RAGZRS"
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-08-storage-replication"
  }
}
