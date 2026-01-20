# terraform-vpc-modules (AWS)

VPC com subnets públicas e privadas em N Availability Zones, Internet Gateway, NAT Gateway (um só ou um por AZ) e route tables. As subnets já saem com as tags que o EKS e o AWS Load Balancer Controller usam: `kubernetes.io/role/elb` nas públicas e `kubernetes.io/role/internal-elb` nas privadas.

## Uso

```hcl
module "vpc" {
  source = "../../terraform-vpc-modules"

  name               = "vpc-eks-lab"
  cidr_block         = "10.0.0.0/16"
  az_count           = 2
  single_nat_gateway = true

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome da VPC e prefixo dos recursos |
| `cidr_block` | `string` | não | CIDR da VPC (padrão `10.0.0.0/16`) |
| `az_count` | `number` | não | AZs usadas, mínimo 2 (padrão `2`) |
| `subnet_newbits` | `number` | não | Bits somados ao prefixo por subnet (padrão `4` → `/20`) |
| `single_nat_gateway` | `bool` | não | Um NAT para todas as AZs (padrão `true`) |
| `public_subnet_tags` | `map(string)` | não | Tags extras nas subnets públicas |
| `private_subnet_tags` | `map(string)` | não | Tags extras nas subnets privadas |
| `tags` | `map(string)` | não | Tags de todos os recursos |

## Outputs

| Nome | Descrição |
|------|-----------|
| `vpc_id` | ID da VPC |
| `vpc_cidr_block` | CIDR da VPC |
| `public_subnet_ids` | IDs das subnets públicas |
| `private_subnet_ids` | IDs das subnets privadas |
| `azs` | AZs usadas |
