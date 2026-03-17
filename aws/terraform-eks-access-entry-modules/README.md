# terraform-eks-access-entry-modules (AWS)

Access Entries do Amazon EKS (`aws_eks_access_entry` + `aws_eks_access_policy_association`): define quem acessa o cluster e com qual permissão, pela API do EKS, sem editar o ConfigMap `aws-auth`. Aceita escopo de cluster inteiro ou por namespace e grupos do Kubernetes para usar com RBAC próprio.

## Uso

```hcl
module "access" {
  source = "../../terraform-eks-access-entry-modules"

  cluster_name = module.eks.name

  access_entries = {
    plataforma = {
      principal_arn = "arn:aws:iam::111122223333:role/plataforma-admin"
      policies = {
        admin = { policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" }
      }
    }
    time-loja = {
      principal_arn = "arn:aws:iam::111122223333:role/time-loja"
      policies = {
        edit = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          scope_type = "namespace"
          namespaces = ["loja"]
        }
      }
    }
  }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `cluster_name` | `string` | sim | Cluster EKS |
| `access_entries` | `map(object)` | não | `principal_arn`, `kubernetes_groups` e `policies` (`policy_arn`, `scope_type`, `namespaces`) |
| `tags` | `map(string)` | não | Tags |

## Outputs

`access_entry_arns`.
