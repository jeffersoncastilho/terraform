variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes do cluster (usada para achar a versão compatível de cada add-on)"
  type        = string
}

variable "addons" {
  description = <<-EOT
    Add-ons por nome. version = null usa a mais recente compatível.
    pod_identity_role_arn + service_account ligam o add-on a uma role via EKS Pod Identity.
    configuration_values aceita o JSON de configuração do add-on (aws eks describe-addon-configuration).
  EOT
  type = map(object({
    version                     = optional(string)
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
    configuration_values        = optional(string)
    pod_identity_role_arn       = optional(string)
    service_account             = optional(string)
  }))
}

variable "tags" {
  description = "Tags dos add-ons"
  type        = map(string)
  default     = {}
}
