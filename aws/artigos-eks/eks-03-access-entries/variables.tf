variable "region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "eks-blog-castilho"
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes (aws eks describe-cluster-versions lista as suportadas)"
  type        = string
  default     = "1.35"
}

variable "authentication_mode" {
  description = "API (só Access Entries) ou API_AND_CONFIG_MAP (transição a partir do aws-auth)"
  type        = string
  default     = "API"
}

variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_access_cidrs" {
  description = "CIDRs autorizados no endpoint público da API (use o IP da sua rede /32)"
  type        = list(string)
}

variable "platform_admin_role_arn" {
  description = "IAM role do time de plataforma (admin do cluster)"
  type        = string
}

variable "team_role_arn" {
  description = "IAM role do time da loja (edição só no namespace loja)"
  type        = string
}

variable "deploy_role_arn" {
  description = "IAM role usada pelo pipeline de deploy da loja (grupo loja-deployers + RBAC próprio)"
  type        = string
}

variable "tags" {
  description = "Tags padrão de todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho-eks"
    managed_by = "terraform"
  }
}
