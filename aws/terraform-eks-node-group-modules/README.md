# terraform-eks-node-group-modules (AWS)

Managed Node Group do Amazon EKS com IAM role própria (WorkerNode, CNI, ECR pull-only e, opcionalmente, SSM), `ON_DEMAND` ou `SPOT`, AMI gerenciada (AL2023 por padrão), labels, taints e `update_config` para controlar a rotação dos nós em upgrades. O `desired_size` é ignorado depois da criação, para não brigar com autoscaler.

## Uso

```hcl
module "ng_spot" {
  source = "../../terraform-eks-node-group-modules"

  cluster_name   = module.eks.name
  name           = "spot"
  subnet_ids     = module.vpc.private_subnet_ids
  capacity_type  = "SPOT"
  instance_types = ["t3.large", "t3a.large", "m5.large", "m6i.large"]

  min_size     = 0
  desired_size = 2
  max_size     = 5

  labels = { "workload" = "spot" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `cluster_name` | `string` | sim | Cluster EKS |
| `name` | `string` | sim | Nome do node group |
| `subnet_ids` | `list(string)` | sim | Subnets dos nós |
| `kubernetes_version` | `string` | não | `null` = versão do control plane |
| `ami_type` | `string` | não | Padrão `AL2023_x86_64_STANDARD` |
| `capacity_type` | `string` | não | `ON_DEMAND` (padrão) ou `SPOT` |
| `instance_types` | `list(string)` | não | Padrão `["t3.medium"]` |
| `disk_size` | `number` | não | GiB (padrão `20`) |
| `min_size` / `desired_size` / `max_size` | `number` | não | Padrão `1` / `2` / `3` |
| `max_unavailable_percentage` | `number` | não | Padrão `33` |
| `labels` | `map(string)` | não | Labels dos nós |
| `taints` | `list(object)` | não | Taints dos nós |
| `enable_ssm` | `bool` | não | Session Manager (padrão `true`) |
| `tags` | `map(string)` | não | Tags |

## Outputs

`node_group_name`, `node_group_arn`, `node_role_arn`, `node_role_name`.
