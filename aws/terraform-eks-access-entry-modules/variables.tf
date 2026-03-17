variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "access_entries" {
  description = <<-EOT
    Mapa de acessos. policies usa as access policies gerenciadas do EKS, ex.:
    arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy
    arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy
    arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy
    arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy
    scope_type = "cluster" (cluster inteiro) ou "namespace" (só os namespaces listados).
  EOT
  type = map(object({
    principal_arn     = string
    kubernetes_groups = optional(list(string), [])
    policies = optional(map(object({
      policy_arn = string
      scope_type = optional(string, "cluster")
      namespaces = optional(list(string), [])
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags das access entries"
  type        = map(string)
  default     = {}
}
