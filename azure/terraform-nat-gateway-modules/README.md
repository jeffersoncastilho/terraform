# terraform-nat-gateway-modules

Módulo Terraform para um Azure NAT Gateway associado a um Public IP e a uma ou mais subnets — saída de internet controlada e previsível (IP público fixo em vez do esquema de SNAT dinâmico do balanceador padrão).

## Uso

```hcl
module "nat_gateway" {
  source                = "../terraform-nat-gateway-modules"
  name                   = "natgw-meulab"
  resource_group_name   = module.rg.name
  location               = "eastus"
  public_ip_address_id  = module.pip_natgw.id
  subnet_ids             = [module.vnet.subnets["app"].id]

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do NAT Gateway |
| `resource_group_name` | `string` | sim | Resource Group do NAT Gateway |
| `location` | `string` | sim | Região Azure |
| `sku_name` | `string` | não | `Standard` (padrão, único SKU disponível) |
| `idle_timeout_in_minutes` | `number` | não | Timeout de conexões ociosas (padrão `4`) |
| `public_ip_address_id` | `string` | sim | Public IP associado |
| `subnet_ids` | `list(string)` | não | Subnets que saem pela internet via este NAT Gateway |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do NAT Gateway |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
