variable "name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes (ex.: 1.35). Consulte as suportadas com: aws eks describe-cluster-versions"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets do control plane (pelo menos 2 AZs; normalmente as privadas)"
  type        = list(string)
}

variable "authentication_mode" {
  description = "API (só Access Entries), API_AND_CONFIG_MAP (transição) ou CONFIG_MAP (legado, aws-auth)"
  type        = string
  default     = "API"

  validation {
    condition     = contains(["API", "API_AND_CONFIG_MAP", "CONFIG_MAP"], var.authentication_mode)
    error_message = "Use API, API_AND_CONFIG_MAP ou CONFIG_MAP."
  }
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Dá permissão de admin a quem criou o cluster (identidade que rodou o apply)"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Expõe o endpoint da API do Kubernetes na internet (filtrado por public_access_cidrs)"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs autorizados no endpoint público. Restrinja ao IP da sua rede em vez de 0.0.0.0/0"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "support_type" {
  description = "STANDARD ou EXTENDED (suporte estendido, cobrado à parte)"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.support_type)
    error_message = "Use STANDARD ou EXTENDED."
  }
}

variable "enabled_cluster_log_types" {
  description = "Logs do control plane enviados ao CloudWatch (api, audit, authenticator, controllerManager, scheduler)"
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "enable_irsa" {
  description = "Cria o provedor OIDC do cluster, necessário para IRSA (não para EKS Pod Identity)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
