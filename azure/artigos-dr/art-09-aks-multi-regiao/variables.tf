variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes para os clusters AKS"
  type        = string
  default     = "1.33"
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-09-aks-multi-regiao"
  }
}
