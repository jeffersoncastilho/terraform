output "role_arn" {
  description = "ARN da IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Nome da IAM role"
  value       = aws_iam_role.this.name
}

output "association_ids" {
  description = "IDs das Pod Identity associations, por namespace/service account"
  value       = { for k, v in aws_eks_pod_identity_association.this : k => v.association_id }
}
