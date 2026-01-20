output "addon_versions" {
  description = "Versão instalada de cada add-on"
  value       = { for k, v in aws_eks_addon.this : k => v.addon_version }
}
