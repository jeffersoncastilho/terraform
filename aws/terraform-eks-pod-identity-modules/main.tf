# EKS Pod Identity: uma IAM role que confia no serviço pods.eks.amazonaws.com
# e uma associação (namespace + service account → role). O pod recebe
# credenciais temporárias pelo eks-pod-identity-agent, sem provedor OIDC e sem
# anotação na service account. Exige o add-on eks-pod-identity-agent.

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy_json != null ? 1 : 0
  name   = "${var.role_name}-inline"
  role   = aws_iam_role.this.id
  policy = var.inline_policy_json
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = { for sa in var.service_accounts : "${sa.namespace}/${sa.name}" => sa }

  cluster_name    = var.cluster_name
  namespace       = each.value.namespace
  service_account = each.value.name
  role_arn        = aws_iam_role.this.arn

  tags = var.tags
}
