# terraform-vnet-peering-modules

Módulo Terraform para criação de peering bidirecional entre duas Virtual Networks no Azure.

Cria os dois recursos `azurerm_virtual_network_peering` (A→B e B→A) em uma única chamada de módulo.

## Uso

```hcl
module "peering_hub_spoke" {
  source = "../terraform-vnet-peering-modules"

  peering_a_name              = "peer-hub-to-spoke-brazilsouth"
  peering_a_rg                = "rg-meulab-network-brazilsouth"
  peering_a_vnet_name         = "vnet-hub-meulab-brazilsouth"
  peering_a_vnet_id           = module.vnet_hub.vnet_id
  peering_a_allow_forwarded_traffic = true
  peering_a_allow_gateway_transit   = true

  peering_b_name              = "peer-spoke-to-hub-brazilsouth"
  peering_b_rg                = "rg-meulab-network-brazilsouth"
  peering_b_vnet_name         = "vnet-spoke-meulab-brazilsouth"
  peering_b_vnet_id           = module.vnet_spoke.vnet_id
  peering_b_allow_forwarded_traffic = true
  peering_b_use_remote_gateways     = false
}
```

## Inputs

| Nome | Tipo | Default | Descrição |
|------|------|---------|-----------|
| `peering_a_name` | `string` | — | Nome do peering A→B |
| `peering_a_rg` | `string` | — | Resource Group da VNet A |
| `peering_a_vnet_name` | `string` | — | Nome da VNet A |
| `peering_a_vnet_id` | `string` | — | ID da VNet A |
| `peering_a_allow_forwarded_traffic` | `bool` | `false` | Permite tráfego encaminhado no lado A |
| `peering_a_allow_gateway_transit` | `bool` | `false` | Permite gateway transit no lado A |
| `peering_a_use_remote_gateways` | `bool` | `false` | Usa gateways remotos no lado A |
| `peering_b_name` | `string` | — | Nome do peering B→A |
| `peering_b_rg` | `string` | — | Resource Group da VNet B |
| `peering_b_vnet_name` | `string` | — | Nome da VNet B |
| `peering_b_vnet_id` | `string` | — | ID da VNet B |
| `peering_b_allow_forwarded_traffic` | `bool` | `false` | Permite tráfego encaminhado no lado B |
| `peering_b_allow_gateway_transit` | `bool` | `false` | Permite gateway transit no lado B |
| `peering_b_use_remote_gateways` | `bool` | `false` | Usa gateways remotos no lado B |

## Outputs

| Nome | Descrição |
|------|-----------|
| `peering_a_to_b_id` | ID do peering A → B |
| `peering_b_to_a_id` | ID do peering B → A |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
