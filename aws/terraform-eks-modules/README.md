# terraform-eks-modules (AWS)

Control plane do Amazon EKS: IAM role do cluster e `aws_eks_cluster` com autenticação por **Access Entries** (`authentication_mode = "API"`), endpoint privado sempre ligado, endpoint público opcional e filtrável por CIDR, política de upgrade (`STANDARD`/`EXTENDED`) e logs do control plane. O provedor OIDC para IRSA é opcional (`enable_irsa`).

Os nós ficam em outro módulo (`terraform-eks-node-group-modules`), assim o mesmo cluster recebe node groups, Fargate ou Karpenter sem mexer aqui.

## Uso

```hcl
module "eks" {
  source = "../../terraform-eks-modules"

  name               = "eks-lab"
  kubernetes_version = "1.35"
  subnet_ids         = module.vpc.private_subnet_ids

  public_access_cidrs = ["203.0.113.10/32"]

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do cluster |
| `kubernetes_version` | `string` | sim | Versão do Kubernetes |
| `subnet_ids` | `list(string)` | sim | Subnets do control plane (2+ AZs) |
| `authentication_mode` | `string` | não | `API` (padrão), `API_AND_CONFIG_MAP` ou `CONFIG_MAP` |
| `bootstrap_cluster_creator_admin_permissions` | `bool` | não | Admin para quem criou (padrão `true`) |
| `endpoint_public_access` | `bool` | não | Endpoint público (padrão `true`) |
| `public_access_cidrs` | `list(string)` | não | CIDRs do endpoint público |
| `support_type` | `string` | não | `STANDARD` (padrão) ou `EXTENDED` |
| `enabled_cluster_log_types` | `list(string)` | não | Logs do control plane |
| `enable_irsa` | `bool` | não | Cria o provedor OIDC (padrão `false`) |
| `tags` | `map(string)` | não | Tags |

## Outputs

`name`, `arn`, `endpoint`, `certificate_authority_data`, `kubernetes_version`, `cluster_security_group_id`, `oidc_issuer_url`, `oidc_provider_arn`.
