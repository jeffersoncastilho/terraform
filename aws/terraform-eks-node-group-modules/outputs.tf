output "node_group_name" {
  description = "Nome do node group"
  value       = aws_eks_node_group.this.node_group_name
}

output "node_group_arn" {
  description = "ARN do node group"
  value       = aws_eks_node_group.this.arn
}

output "node_role_arn" {
  description = "ARN da IAM role dos nós"
  value       = aws_iam_role.node.arn
}

output "node_role_name" {
  description = "Nome da IAM role dos nós"
  value       = aws_iam_role.node.name
}
