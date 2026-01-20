output "name" {
  description = "Nome do cluster"
  value       = aws_eks_cluster.this.name
}

output "arn" {
  description = "ARN do cluster"
  value       = aws_eks_cluster.this.arn
}

output "endpoint" {
  description = "Endpoint da API do Kubernetes"
  value       = aws_eks_cluster.this.endpoint
}

output "certificate_authority_data" {
  description = "CA do cluster (base64)"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "kubernetes_version" {
  description = "Versão do Kubernetes do control plane"
  value       = aws_eks_cluster.this.version
}

output "cluster_security_group_id" {
  description = "Security group criado pelo EKS para o cluster"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "oidc_issuer_url" {
  description = "URL do emissor OIDC do cluster"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "ARN do provedor OIDC (null se enable_irsa = false)"
  value       = var.enable_irsa ? aws_iam_openid_connect_provider.this[0].arn : null
}
