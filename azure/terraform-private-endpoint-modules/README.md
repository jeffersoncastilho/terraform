# terraform-private-endpoint-modules

Módulo Terraform genérico para um `azurerm_private_endpoint`, reutilizável para consumir qualquer recurso via Private Link (Storage, SQL, Private Link Service customizado, etc.) — não fica restrito a um tipo de recurso específico.

## Uso — consumindo um Private Link Service

```hcl
module "pe_pls" {
  source                          = "../terraform-private-endpoint-modules"
  name                            = "pe-meulab"
  resource_group_name             = module.rg.name
  location                        = "eastus"
  subnet_id                       = module.vnet_consumer.subnets["consumer"].id
  private_connection_resource_id  = module.pls.id
  # subresource_names não se aplica a Private Link Service

  tags = { managed_by = "terraform" }
}
```

## Uso — consumindo um Storage Account (subresource)

```hcl
module "pe_storage" {
  source                          = "../terraform-private-endpoint-modules"
  name                            = "pe-storage-meulab"
  resource_group_name             = module.rg.name
  location                        = "eastus"
  subnet_id                       = module.vnet.subnets["private"].id
  private_connection_resource_id  = module.storage.storage_account_id
  subresource_names               = ["blob"]
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Private Endpoint |
| `resource_group_name` | `string` | sim | Resource Group do recurso |
| `location` | `string` | sim | Região Azure |
| `subnet_id` | `string` | sim | Subnet (com `private_endpoint_network_policies = Disabled`) |
| `private_connection_resource_id` | `string` | sim | ID do recurso consumido |
| `subresource_names` | `list(string)` | não | Sub-recurso alvo (`null` para Private Link Service) |
| `is_manual_connection` | `bool` | não | Requer aprovação manual (padrão `false`) |
| `private_dns_zone_ids` | `list(string)` | não | Private DNS Zones pra registro automático |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Private Endpoint |
| `private_ip_address` | IP privado atribuído |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
