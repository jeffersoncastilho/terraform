# terraform-public-ip-modules

Módulo Terraform para criação de um IP público (`azurerm_public_ip`) no Azure — usado como building block por outros módulos/artigos que precisam de um IP público dedicado (VPN Gateway, Application Gateway, NAT Gateway, Bastion, etc.).

## Uso

```hcl
module "pip_vpngw" {
  source              = "../terraform-public-ip-modules"
  name                = "pip-vpngw-meulab"
  resource_group_name = module.rg.name
  location            = "eastus"

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Public IP |
| `resource_group_name` | `string` | sim | Resource Group onde o Public IP será criado |
| `location` | `string` | sim | Região Azure |
| `allocation_method` | `string` | não | `Static` (padrão) ou `Dynamic` |
| `sku` | `string` | não | `Standard` (padrão) ou `Basic` |
| `zones` | `list(string)` | não | Zonas de disponibilidade |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Public IP |
| `ip_address` | Endereço IP alocado |
| `name` | Nome do Public IP |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
