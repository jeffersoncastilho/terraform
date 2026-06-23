output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.name
}

output "kubernetes_version" {
  description = "Versão do Kubernetes do control plane"
  value       = module.eks.kubernetes_version
}

output "vpc_id" {
  description = "ID da VPC do cluster (a mesma passada ao controller)"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Subnets públicas, com a tag kubernetes.io/role/elb, onde nascem os ALBs internet-facing"
  value       = module.vpc.public_subnet_ids
}

output "lb_controller_role_arn" {
  description = "ARN da IAM role do AWS Load Balancer Controller (via Pod Identity)"
  value       = module.lb_controller.role_arn
}

output "lb_controller_chart_version" {
  description = "Versão do chart do AWS Load Balancer Controller"
  value       = module.lb_controller.chart_version
}

output "kubeconfig_command" {
  description = "Comando para configurar o kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.name}"
}
