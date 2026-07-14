# terraform-eks-karpenter-modules (AWS)

Karpenter no Amazon EKS em um módulo:

- IAM role dos nós (`KarpenterNodeRole-<cluster>`) com as políticas de worker, CNI, ECR pull-only e SSM, e a **access entry** `EC2_LINUX` para os nós se registrarem no cluster;
- IAM role do controller via **EKS Pod Identity**, com a política oficial do projeto (`controller-policy.json.tftpl`);
- fila SQS de interrupção e cinco regras do EventBridge (Spot, rebalance, manutenção agendada, mudança de estado e reserva de capacidade);
- chart `oci://public.ecr.aws/karpenter/karpenter` com `helm_release`.

A política e os recursos de interrupção são a tradução do `cloudformation.yaml` do guia *Getting Started with Karpenter* da mesma versão do chart. Exige o add-on `eks-pod-identity-agent`, um node group gerenciado para o próprio controller rodar e o provider `helm` configurado no ambiente. `EC2NodeClass` e `NodePool` ficam fora do módulo (YAML aplicado com `kubectl`).

## Uso

```hcl
module "karpenter" {
  source = "../../terraform-eks-karpenter-modules"

  cluster_name  = module.eks.name
  chart_version = "1.13.1"
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `cluster_name` | `string` | sim | Cluster EKS |
| `chart_version` | `string` | sim | Versão do chart (sem `v`) |
| `namespace` | `string` | não | Padrão `kube-system` |
| `service_account_name` | `string` | não | Padrão `karpenter` |
| `replicas` | `number` | não | Padrão `2` |
| `tags` | `map(string)` | não | Tags |

## Outputs

| Nome | Descrição |
|------|-----------|
| `node_role_name` | Role dos nós (usada no `spec.role` do `EC2NodeClass`) |
| `node_role_arn` | ARN da role dos nós |
| `controller_role_arn` | ARN da role do controller |
| `interruption_queue_name` | Fila SQS de interrupção |
| `chart_version` | Versão do chart instalada |
