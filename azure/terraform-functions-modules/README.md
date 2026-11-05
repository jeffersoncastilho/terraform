# terraform-functions-modules

Módulo Terraform para um App Service Plan + Linux Function App, com integração de VNet regional opcional (`subnet_id`) — exige plano Elastic Premium (EP1+) ou Dedicated, o plano Consumption não suporta.

## Uso — com integração de VNet (Elastic Premium)

```hcl
module "functions" {
  source                        = "../terraform-functions-modules"
  name                            = "func-meulab"
  plan_name                       = "plan-func-meulab"
  resource_group_name            = module.rg.name
  location                        = "eastus"
  sku_name                         = "EP1"
  storage_account_name            = module.storage.storage_account_name
  storage_account_access_key      = module.storage.primary_access_key
  subnet_id                        = module.vnet.subnets["functions"].id

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome da Function App (globalmente único) |
| `plan_name` | `string` | sim | Nome do App Service Plan |
| `resource_group_name` | `string` | sim | Resource Group dos recursos |
| `location` | `string` | sim | Região Azure |
| `sku_name` | `string` | não | Padrão `EP1` |
| `storage_account_name` / `storage_account_access_key` | `string` | sim | Storage obrigatório para qualquer Function App |
| `subnet_id` | `string` | não | `null` (padrão) não integra a nenhuma VNet |
| `node_version` | `string` | não | Padrão `20` |
| `app_settings` | `map(string)` | não | App settings adicionais |
| `tags` | `map(string)` | não | Tags aplicadas aos recursos |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID da Function App |
| `default_hostname` | Hostname padrão |
| `plan_id` | ID do App Service Plan |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
