# terraform-eks-lb-controller-modules (AWS)

AWS Load Balancer Controller no Amazon EKS: IAM role com a política oficial (`iam_policy.json`, da mesma versão do chart) ligada à service account por **EKS Pod Identity** e instalação do chart `eks/aws-load-balancer-controller` com `helm_release`. Usa `terraform-eks-pod-identity-modules` e exige o add-on `eks-pod-identity-agent` no cluster.

O ambiente que chama o módulo precisa configurar o provider `helm` apontando para o cluster.

## Uso

```hcl
module "lb_controller" {
  source = "../../terraform-eks-lb-controller-modules"

  cluster_name  = module.eks.name
  region        = var.region
  vpc_id        = module.vpc.vpc_id
  chart_version = "3.4.0"
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `cluster_name` | `string` | sim | Cluster EKS |
| `region` | `string` | sim | Região do cluster |
| `vpc_id` | `string` | sim | VPC do cluster |
| `chart_version` | `string` | sim | Versão do chart |
| `namespace` | `string` | não | Padrão `kube-system` |
| `service_account_name` | `string` | não | Padrão `aws-load-balancer-controller` |
| `replica_count` | `number` | não | Padrão `2` |
| `tags` | `map(string)` | não | Tags |

## Outputs

| Nome | Descrição |
|------|-----------|
| `role_arn` | ARN da IAM role do controller |
| `release_name` | Nome do release Helm |
| `chart_version` | Versão do chart instalada |

## Atualizando a política

Ao subir `chart_version`, troque também o `iam_policy.json` pela versão da nova tag:

```bash
curl -o iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v<versão>/docs/install/iam_policy.json
```
