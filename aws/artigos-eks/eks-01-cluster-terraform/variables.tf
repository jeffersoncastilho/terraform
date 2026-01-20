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
  default     = "1.34"
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
