output "role_arn" {
  description = "ARN da IAM role do controller"
  value       = module.pod_identity.role_arn
}

output "release_name" {
  description = "Nome do release Helm"
  value       = helm_release.this.name
}

output "chart_version" {
  description = "Versão do chart instalada"
  value       = helm_release.this.version
}
