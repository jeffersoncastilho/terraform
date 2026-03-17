output "access_entry_arns" {
  description = "ARNs das access entries, por chave"
  value       = { for k, v in aws_eks_access_entry.this : k => v.access_entry_arn }
}
