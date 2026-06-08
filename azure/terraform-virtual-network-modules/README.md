# terraform-virtual-network-modules

Módulo Terraform para criação de Virtual Networks com subnets no Azure.

## Uso

```hcl
module "vnet_hub" {
  source              = "../terraform-virtual-network-modules"
  name                = "vnet-hub-meulab-brazilsouth"
  resource_group_name = "rg-meulab-network-brazilsouth"
  location            = "brazilsouth"
  address_space       = ["10.0.0.0/16"]

  subnets = [
    { key = "firewall",   name = "AzureFirewallSubnet", address_prefixes = ["10.0.0.0/26"] },
    { key = "bastion",    name = "AzureBastionSubnet",  address_prefixes = ["10.0.0.128/26"] },
    { key = "management", name = "snet-management",     address_prefixes = ["10.0.0.192/27"] },
  ]

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome da Virtual Network |
| `resource_group_name` | `string` | sim | Resource Group onde a VNet será criada |
| `location` | `string` | sim | Região Azure (ex: `brazilsouth`, `eastus`) |
| `address_space` | `list(string)` | sim | Blocos CIDR da VNet |
| `subnets` | `list(object)` | não | Lista de subnets — cada item: `key`, `name`, `address_prefixes` |
| `tags` | `map(string)` | não | Tags aplicadas à VNet |

## Outputs

| Nome | Descrição |
|------|-----------|
| `vnet_id` | ID da Virtual Network |
| `vnet_name` | Nome da Virtual Network |
| `resource_group_name` | Resource Group da VNet |
| `subnets` | Map das subnets criadas |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
