variable "cluster_name" {
  description = "Nome do cluster EKS (também nomeia a fila SQS e as roles)"
  type        = string
}

variable "chart_version" {
  description = "Versão do chart oci://public.ecr.aws/karpenter/karpenter (sem o v)"
  type        = string
}

variable "namespace" {
  description = "Namespace do controller"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Service account do controller (a mesma da associação do Pod Identity)"
  type        = string
  default     = "karpenter"
}

variable "replicas" {
  description = "Réplicas do controller"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags aplicadas aos recursos da AWS"
  type        = map(string)
  default     = {}
}
