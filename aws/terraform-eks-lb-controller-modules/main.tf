# AWS Load Balancer Controller: IAM role via EKS Pod Identity + Helm chart
# oficial (eks/aws-load-balancer-controller). O controller lê Ingress e
# Service do Kubernetes e cria ALB/NLB, target groups e listeners na AWS.
#
# iam_policy.json é a política oficial publicada no repositório
# kubernetes-sigs/aws-load-balancer-controller (docs/install/iam_policy.json)
# para a mesma versão do chart. Ao subir o chart, baixe a política da nova tag.

module "pod_identity" {
  source = "../terraform-eks-pod-identity-modules"

  cluster_name = var.cluster_name
  role_name    = "${var.cluster_name}-aws-lb-controller"

  service_accounts = [
    { namespace = var.namespace, name = var.service_account_name },
  ]

  inline_policy_json = file("${path.module}/iam_policy.json")

  tags = var.tags
}

resource "helm_release" "this" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version
  namespace  = var.namespace

  # region e vpcId explícitos: o controller não depende de consultar o
  # metadata da instância (IMDS) para descobri-los.
  set = [
    { name = "clusterName", value = var.cluster_name },
    { name = "region", value = var.region },
    { name = "vpcId", value = var.vpc_id },
    { name = "replicaCount", value = tostring(var.replica_count) },
    { name = "serviceAccount.create", value = "true" },
    { name = "serviceAccount.name", value = var.service_account_name },
  ]

  # A associação do Pod Identity precisa existir antes do pod subir; senão o
  # controller inicia sem credencial e falha ao chamar a API do ELB.
  depends_on = [module.pod_identity]
}
