# Add-ons gerenciados do EKS (vpc-cni, coredns, kube-proxy,
# eks-pod-identity-agent, aws-ebs-csi-driver, amazon-cloudwatch-observability...).
# Sem versão informada, usa a mais recente compatível com a versão do cluster.

data "aws_eks_addon_version" "latest" {
  for_each = { for k, v in var.addons : k => v if v.version == null }

  addon_name         = each.key
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}

resource "aws_eks_addon" "this" {
  for_each = var.addons

  cluster_name  = var.cluster_name
  addon_name    = each.key
  addon_version = each.value.version != null ? each.value.version : data.aws_eks_addon_version.latest[each.key].version

  # OVERWRITE: o add-on gerenciado vence mudanças feitas à mão nos objetos dele.
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update

  configuration_values = each.value.configuration_values

  dynamic "pod_identity_association" {
    for_each = each.value.pod_identity_role_arn != null ? [1] : []
    content {
      role_arn        = each.value.pod_identity_role_arn
      service_account = each.value.service_account
    }
  }

  tags = var.tags
}
