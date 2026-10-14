# terraform-expressroute-modules

Módulo Terraform para um ExpressRoute Circuit (`azurerm_express_route_circuit`) — o recurso cobrado mensalmente e que exige negociação com o provedor de conectividade. Não inclui a ExpressRoute Gateway nem a conexão com a VNet (compostas no chamador, análogo ao padrão do `terraform-vpn-gateway-modules`).

## Uso

```hcl
module "expressroute" {
  source                  = "../terraform-expressroute-modules"
  name                     = "expressroute-meulab"
  resource_group_name     = module.rg.name
  location                 = "eastus"
  service_provider_name    = "Equinix"
  peering_location         = "Washington DC"
  bandwidth_in_mbps        = 50

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do circuito |
| `resource_group_name` | `string` | sim | Resource Group do circuito |
| `location` | `string` | sim | Região Azure |
| `service_provider_name` | `string` | sim | Provedor de conectividade |
| `peering_location` | `string` | sim | Local de peering físico |
| `bandwidth_in_mbps` | `number` | não | Largura de banda (padrão `50`) |
| `sku_tier` | `string` | não | `Standard` (padrão), `Premium` ou `Local` |
| `sku_family` | `string` | não | `MeteredData` (padrão) ou `UnlimitedData` |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do ExpressRoute Circuit |
| `service_key` | Chave repassada ao provedor pra provisionar o circuito físico |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
