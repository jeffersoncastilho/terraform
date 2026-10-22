# terraform-network-watcher-modules

Módulo Terraform para um **VNet Flow Log** (com Traffic Analytics opcional), referenciando o Network Watcher que o Azure já cria automaticamente por região (`NetworkWatcher_<região>`, resource group `NetworkWatcherRG`) — o módulo não cria um `azurerm_network_watcher` novo, o que causaria conflito na maioria das subscriptions.

> NSG Flow Logs (o recurso "clássico", associado a um NSG específico) pararam de aceitar criação nova em 30/06/2025 e serão aposentados em 30/09/2027. Este módulo usa **VNet Flow Log** (`target_resource_id` = VNet inteira), o substituto atual.

## Uso

```hcl
module "flow_log" {
  source                                    = "../terraform-network-watcher-modules"
  name                                      = "flowlog-meulab"
  location                                  = "eastus"
  target_resource_id                        = module.vnet.vnet_id
  storage_account_id                        = module.storage.storage_account_id
  traffic_analytics_workspace_id            = module.log_analytics.workspace_id
  traffic_analytics_workspace_region        = "eastus"
  traffic_analytics_workspace_resource_id   = module.log_analytics.id

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Flow Log |
| `location` | `string` | sim | Região — usada para montar `NetworkWatcher_<região>` |
| `target_resource_id` | `string` | sim | ID da VNet alvo |
| `storage_account_id` | `string` | sim | Storage Account que recebe os logs brutos |
| `retention_days` | `number` | não | Retenção em dias (padrão `7`) |
| `traffic_analytics_workspace_id` | `string` | não | `null` desativa o Traffic Analytics |
| `traffic_analytics_workspace_region` | `string` | não | Obrigatório se Traffic Analytics ativo |
| `traffic_analytics_workspace_resource_id` | `string` | não | Obrigatório se Traffic Analytics ativo |
| `traffic_analytics_interval_minutes` | `number` | não | `10` (padrão) ou `60` |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Flow Log |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
