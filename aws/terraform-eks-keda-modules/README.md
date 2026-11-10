# terraform-eks-keda-modules (AWS)

KEDA (Kubernetes Event-driven Autoscaling) no Amazon EKS em um módulo:

- chart oficial `kedacore/keda` (`https://kedacore.github.io/charts`) com `helm_release`, no namespace `keda`;
- `nodeSelector` único para operator, metrics server e webhooks (para o KEDA ficar nos nós fixos do cluster);
- quando `sqs_queue_arns` é informado, IAM role `KedaOperator-<cluster>` via **EKS Pod Identity** para a service account `keda-operator`, só com `sqs:GetQueueAttributes` e `sqs:GetQueueUrl` nessas filas.

Com `podIdentity.provider: aws` e sem `roleArn` na `TriggerAuthentication`, o KEDA usa a cadeia padrão de credenciais do AWS SDK, que entende o EKS Pod Identity. Exige o add-on `eks-pod-identity-agent` e o provider `helm` configurado no ambiente. `ScaledObject` e `TriggerAuthentication` ficam fora do módulo (YAML aplicado com `kubectl`).

## Uso

```hcl
module "keda" {
  source = "../../terraform-eks-keda-modules"

  cluster_name   = module.eks.name
  chart_version  = "2.21.0"
  sqs_queue_arns = [aws_sqs_queue.jobs.arn]
  node_selector  = { "node-role" = "system" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `cluster_name` | `string` | sim | Cluster EKS |
| `chart_version` | `string` | sim | Versão do chart (sem `v`) |
| `namespace` | `string` | não | Padrão `keda` |
| `sqs_queue_arns` | `list(string)` | não | Filas que o operator lê; vazio = sem role |
| `node_selector` | `map(string)` | não | nodeSelector dos pods do KEDA |
| `operator_replicas` | `number` | não | Padrão `1` |
| `tags` | `map(string)` | não | Tags |

## Outputs

| Nome | Descrição |
|------|-----------|
| `namespace` | Namespace do KEDA |
| `chart_version` | Versão do chart instalada |
| `operator_role_arn` | ARN da role do operator (ou `null`) |
