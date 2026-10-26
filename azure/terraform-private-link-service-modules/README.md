# terraform-private-link-service-modules

Módulo Terraform para expor um Load Balancer interno via **Private Link Service**, consumível por outra VNet (até de outra subscription/tenant) através de um Private Endpoint — sem peering, sem rota, sem exposição pública.

## Uso

```hcl
module "pls" {
  source                                      = "../terraform-private-link-service-modules"
  name                                        = "pls-meulab"
  resource_group_name                         = module.rg.name
  location                                    = "eastus"
  nat_subnet_id                               = module.vnet_provider.subnets["pls_nat"].id
  load_balancer_frontend_ip_configuration_id  = module.lb_internal.frontend_ip_configuration_id

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Private Link Service |
| `resource_group_name` | `string` | sim | Resource Group do recurso |
| `location` | `string` | sim | Região Azure |
| `nat_subnet_id` | `string` | sim | Subnet dedicada aos IPs de NAT internos |
| `load_balancer_frontend_ip_configuration_id` | `string` | sim | Frontend do LB interno exposto |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Private Link Service |
| `name` | Nome do Private Link Service |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
