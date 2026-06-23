variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "region" {
  description = "Região AWS do cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC do cluster (passada ao controller para não depender do IMDS)"
  type        = string
}

variable "chart_version" {
  description = "Versão do chart eks/aws-load-balancer-controller (helm search repo eks/aws-load-balancer-controller --versions)"
  type        = string
}

variable "namespace" {
  description = "Namespace do controller"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Service account do controller (a mesma usada na associação do Pod Identity)"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "replica_count" {
  description = "Réplicas do controller (2 = alta disponibilidade do webhook)"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags da IAM role e da associação"
  type        = map(string)
  default     = {}
}
