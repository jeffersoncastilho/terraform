output "namespace" {
  description = "Namespace do KEDA"
  value       = helm_release.this.namespace
}

output "chart_version" {
  description = "Versão do chart instalada"
  value       = helm_release.this.version
}

output "operator_role_arn" {
  description = "ARN da role do operator via Pod Identity (null se não houver fila)"
  value       = length(module.pod_identity) > 0 ? module.pod_identity[0].role_arn : null
}
