# Control plane do Amazon EKS: IAM role do cluster + aws_eks_cluster.
#
# Autenticação no modo API (Access Entries): quem acessa o cluster é definido
# por recursos aws_eks_access_entry, não mais pelo ConfigMap aws-auth.
# bootstrap_cluster_creator_admin_permissions = true dá admin a quem rodou o
# apply, para não ficar trancado fora do cluster no primeiro acesso.

data "aws_iam_policy_document" "cluster_assume" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name               = "${var.name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "this" {
  name     = var.name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.cluster.arn

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  # STANDARD: ao fim do suporte padrão o cluster é atualizado automaticamente.
  # EXTENDED: fica mais 12 meses na versão, cobrando a tarifa de suporte estendido.
  upgrade_policy {
    support_type = var.support_type
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = var.tags

  depends_on = [aws_iam_role_policy_attachment.cluster]
}

# Provedor OIDC do cluster: só é necessário para IRSA (IAM Roles for Service
# Accounts). Com EKS Pod Identity ele não é usado.
data "tls_certificate" "oidc" {
  count = var.enable_irsa ? 1 : 0
  url   = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  count = var.enable_irsa ? 1 : 0

  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc[0].certificates[0].sha1_fingerprint]

  tags = var.tags
}
