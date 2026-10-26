# terraform-load-balancer-modules

Módulo Terraform para um Load Balancer **interno** (sem IP público) com um backend pool, um probe e uma regra — o padrão mínimo usado como alvo de um Private Link Service ou para balancear tráfego dentro de uma VNet.

## Uso

```hcl
module "lb_internal" {
  source              = "../terraform-load-balancer-modules"
  name                = "lb-internal-meulab"
  resource_group_name = module.rg.name
  location            = "eastus"
  frontend_subnet_id  = module.vnet.subnets["provider"].id
  protocol            = "Tcp"
  port                = 80

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Load Balancer |
| `resource_group_name` | `string` | sim | Resource Group do Load Balancer |
| `location` | `string` | sim | Região Azure |
| `sku` | `string` | não | `Standard` (padrão) ou `Basic` |
| `frontend_name` | `string` | não | Nome da config de frontend (padrão `frontend-internal`) |
| `frontend_subnet_id` | `string` | sim | Subnet do frontend interno |
| `protocol` | `string` | não | `Tcp` (padrão), `Udp` ou `Http` |
| `port` | `number` | não | Porta da regra/probe (padrão `80`) |
| `tags` | `map(string)` | não | Tags aplicadas aos recursos |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Load Balancer |
| `frontend_ip_configuration_id` | ID da config de frontend — alvo de um Private Link Service |
| `backend_address_pool_id` | ID do backend pool |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
