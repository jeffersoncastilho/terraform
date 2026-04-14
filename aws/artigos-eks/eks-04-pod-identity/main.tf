# IAM para pods com EKS Pod Identity: o pod "catalogo" (namespace loja) lê um
# bucket S3 com uma política mínima, sem access key e sem provedor OIDC.
# Série: artigos-eks | Artigo: eks-04-pod-identity
#
# Pré-requisito no cluster: add-on eks-pod-identity-agent (já incluído abaixo).
# IRSA fica desligado (enable_irsa = false); o artigo compara as duas opções.

module "vpc" {
  source = "../../terraform-vpc-modules"

  name               = "vpc-${var.cluster_name}"
  cidr_block         = var.vpc_cidr
  az_count           = 2
  single_nat_gateway = true
}

module "eks" {
  source = "../../terraform-eks-modules"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  subnet_ids         = module.vpc.private_subnet_ids

  # Pod Identity não usa o provedor OIDC do cluster.
  enable_irsa = false

  public_access_cidrs = var.public_access_cidrs
}

module "ng_default" {
  source = "../../terraform-eks-node-group-modules"

  cluster_name   = module.eks.name
  name           = "default"
  subnet_ids     = module.vpc.private_subnet_ids
  instance_types = ["t3.medium"]

  min_size     = 1
  desired_size = 2
  max_size     = 3
}

module "addons" {
  source = "../../terraform-eks-addon-modules"

  cluster_name       = module.eks.name
  kubernetes_version = module.eks.kubernetes_version

  addons = {
    vpc-cni                = {}
    coredns                = {}
    kube-proxy             = {}
    eks-pod-identity-agent = {}
  }

  depends_on = [module.ng_default]
}

# Política mínima: listar o bucket e ler objetos só do prefixo produtos/.
data "aws_iam_policy_document" "catalogo_s3" {
  statement {
    sid       = "ListarProdutos"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.catalog_bucket_name}"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["produtos/*"]
    }
  }

  statement {
    sid       = "LerProdutos"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.catalog_bucket_name}/produtos/*"]
  }
}

module "pi_catalogo" {
  source = "../../terraform-eks-pod-identity-modules"

  cluster_name = module.eks.name
  role_name    = "${var.cluster_name}-catalogo-s3"

  service_accounts = [
    { namespace = "loja", name = "catalogo" },
  ]

  inline_policy_json = data.aws_iam_policy_document.catalogo_s3.json

  depends_on = [module.addons]
}
