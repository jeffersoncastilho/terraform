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

variable "cluster_version" {
  description = "Versão do control plane. Suba uma versão menor por vez (1.35 → 1.36)"
  type        = string
  default     = "1.35"
}

variable "node_group_version" {
  description = "Versão do kubelet dos nós. Suba depois do control plane, nunca antes"
  type        = string
  default     = "1.35"
}

variable "support_type" {
  description = "STANDARD (atualiza sozinho no fim do suporte padrão) ou EXTENDED (mais 12 meses, cobrado à parte)"
  type        = string
  default     = "STANDARD"
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

variable "tags" {
  description = "Tags padrão de todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho-eks"
    managed_by = "terraform"
  }
}
