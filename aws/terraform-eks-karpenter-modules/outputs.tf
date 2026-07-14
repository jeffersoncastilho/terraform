output "node_role_name" {
  description = "Nome da IAM role dos nós (vai no spec.role do EC2NodeClass)"
  value       = aws_iam_role.node.name
}

output "node_role_arn" {
  description = "ARN da IAM role dos nós"
  value       = aws_iam_role.node.arn
}

output "controller_role_arn" {
  description = "ARN da IAM role do controller (via Pod Identity)"
  value       = module.pod_identity.role_arn
}

output "interruption_queue_name" {
  description = "Fila SQS que recebe os avisos de interrupção"
  value       = aws_sqs_queue.interruption.name
}

output "chart_version" {
  description = "Versão do chart instalada"
  value       = helm_release.this.version
}
