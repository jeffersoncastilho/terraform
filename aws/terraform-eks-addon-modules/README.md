# terraform-eks-addon-modules (AWS)

Add-ons gerenciados do Amazon EKS em um único bloco: versão fixa ou a mais recente compatível com o cluster, `configuration_values` em JSON e associação opcional com uma IAM role via EKS Pod Identity (`pod_identity_role_arn` + `service_account`).

## Uso

```hcl
module "addons" {
  source = "../../terraform-eks-addon-modules"

  cluster_name       = module.eks.name
  kubernetes_version = module.eks.kubernetes_version

  addons = {
    vpc-cni                = {}
    coredns                = {}
    kube-proxy             = {}
    eks-pod-identity-agent = {}
    aws-ebs-csi-driver = {
      pod_identity_role_arn = module.pi_ebs.role_arn
      service_account       = "ebs-csi-controller-sa"
    }
  }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `cluster_name` | `string` | sim | Cluster EKS |
| `kubernetes_version` | `string` | sim | Versão do cluster |
| `addons` | `map(object)` | sim | `version`, `resolve_conflicts_on_update`, `configuration_values`, `pod_identity_role_arn`, `service_account` |
| `tags` | `map(string)` | não | Tags |

## Outputs

`addon_versions`.
