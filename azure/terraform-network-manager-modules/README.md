# terraform-network-manager-modules

Módulo Terraform para um Azure Virtual Network Manager governando um grupo de VNets: topologia de conectividade (peering automático, sem `azurerm_virtual_network_peering` manual) e regras de Security Admin com prioridade acima de qualquer NSG local.

## Uso

```hcl
module "network_manager" {
  source              = "../terraform-network-manager-modules"
  name                = "avnm-meulab"
  resource_group_name = module.rg.name
  location             = "eastus"
  subscription_id      = var.subscription_id
  network_group_name   = "ng-app-vnets"

  member_vnet_ids = {
    frontend = module.vnet_frontend.vnet_id
    backend  = module.vnet_backend.vnet_id
  }

  connectivity_topology = "Mesh"

  admin_rules = [{
    name                             = "deny-rdp-ssh-from-internet"
    action                           = "Deny"
    direction                        = "Inbound"
    priority                         = 100
    protocol                         = "Tcp"
    source_address_prefix_type       = "ServiceTag"
    source_address_prefix            = "Internet"
    destination_address_prefix_type  = "IPPrefix"
    destination_address_prefix       = "*"
    source_port_ranges               = ["0-65535"]
    destination_port_ranges          = ["22", "3389"]
  }]

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Network Manager |
| `resource_group_name` | `string` | sim | Resource Group do Network Manager |
| `location` | `string` | sim | Região Azure |
| `subscription_id` | `string` | sim | Subscription no escopo de governança |
| `scope_accesses` | `list(string)` | não | Padrão `["Connectivity", "SecurityAdmin"]` |
| `network_group_name` | `string` | sim | Nome do grupo de rede |
| `member_vnet_ids` | `map(string)` | sim | VNets membros (chave arbitrária => ID) |
| `enable_connectivity_configuration` | `bool` | não | Padrão `true` |
| `connectivity_topology` | `string` | não | `Mesh` (padrão) ou `HubAndSpoke` |
| `admin_rules` | `list(object)` | não | Lista vazia (padrão) não cria Security Admin Configuration |
| `tags` | `map(string)` | não | Tags aplicadas ao Network Manager |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Network Manager |
| `network_group_id` | ID do grupo de rede |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
