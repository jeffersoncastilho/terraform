# terraform-eks-pod-identity-modules (AWS)

IAM role para pods com **EKS Pod Identity**: trust policy em `pods.eks.amazonaws.com`, políticas gerenciadas e/ou inline e uma `aws_eks_pod_identity_association` por service account. Não precisa de provedor OIDC nem de anotação na service account. Requer o add-on `eks-pod-identity-agent` no cluster.

## Uso

```hcl
module "pi_catalogo" {
  source = "../../terraform-eks-pod-identity-modules"

  cluster_name = module.eks.name
  role_name    = "eks-lab-catalogo-s3"

  service_accounts = [{ namespace = "loja", name = "catalogo" }]

  inline_policy_json = data.aws_iam_policy_document.catalogo_s3.json
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `cluster_name` | `string` | sim | Cluster EKS |
| `role_name` | `string` | sim | Nome da IAM role |
| `service_accounts` | `list(object)` | sim | `namespace` + `name` |
| `policy_arns` | `list(string)` | não | Políticas gerenciadas |
| `inline_policy_json` | `string` | não | Política inline |
| `tags` | `map(string)` | não | Tags |

## Outputs

`role_arn`, `role_name`, `association_ids`.
