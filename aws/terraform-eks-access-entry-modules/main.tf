# Access Entries do EKS: quem (IAM role/user) acessa o cluster e com qual
# permissão do Kubernetes, gerenciado pela API do EKS em vez do ConfigMap
# aws-auth. Exige o cluster em authentication_mode API ou API_AND_CONFIG_MAP.

resource "aws_eks_access_entry" "this" {
  for_each = var.access_entries

  cluster_name      = var.cluster_name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = each.value.kubernetes_groups
  type              = "STANDARD"

  tags = var.tags
}

locals {
  # Achata entries × policies num mapa único para o for_each das associações.
  associations = merge([
    for entry_key, entry in var.access_entries : {
      for policy_key, policy in entry.policies :
      "${entry_key}/${policy_key}" => {
        principal_arn = entry.principal_arn
        policy_arn    = policy.policy_arn
        scope_type    = policy.scope_type
        namespaces    = policy.namespaces
      }
    }
  ]...)
}

resource "aws_eks_access_policy_association" "this" {
  for_each = local.associations

  cluster_name  = var.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type       = each.value.scope_type
    namespaces = each.value.scope_type == "namespace" ? each.value.namespaces : null
  }

  depends_on = [aws_eks_access_entry.this]
}
