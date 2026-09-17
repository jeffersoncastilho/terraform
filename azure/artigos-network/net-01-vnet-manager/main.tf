# Azure Virtual Network Manager: topologia (mesh) e regra de segurança admin
# centralizadas sobre 3 VNets de exemplo (frontend / backend / shared).
# Série: artigos-network | Artigo: net-01-vnet-manager
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules (uma
# instância por VNet via for_each no bloco module) e o novo
# terraform-network-manager-modules, que encapsula Network Manager + grupo +
# membros estáticos + connectivity configuration + security admin
# configuration + regras + deployments.

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-vnet-manager"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

# ── VNets de exemplo ("times/apps" que o Network Manager vai governar) ────────

module "vnets" {
  source   = "../../terraform-virtual-network-modules"
  for_each = var.vnets

  name                = "vnet-${each.key}-blog-castilho"
  resource_group_name = module.rg.name
  location             = var.location
  address_space        = [each.value.address_space]

  subnets = [
    { key = "default", name = "snet-${each.key}", address_prefixes = [each.value.subnet_prefix] },
  ]

  tags = var.tags
}

# ── Azure Virtual Network Manager: grupo, topologia mesh e baseline de segurança
# O Network Manager cria e mantém o peering entre as VNets do grupo
# automaticamente — sem precisar declarar azurerm_virtual_network_peering
# para cada par. A regra de segurança se aplica a TODAS as VNets do grupo,
# com prioridade acima de qualquer NSG local — bloqueia RDP/SSH vindos da
# Internet mesmo que alguém esqueça de configurar o NSG numa VNet nova.

module "network_manager" {
  source = "../../terraform-network-manager-modules"

  name                 = "avnm-blog-castilho"
  resource_group_name = module.rg.name
  location             = var.location
  subscription_id      = var.subscription_id
  network_group_name   = "ng-app-vnets"

  member_vnet_ids = { for k, v in module.vnets : k => v.vnet_id }

  connectivity_topology            = "Mesh"
  connectivity_configuration_name  = "conn-mesh-app-vnets"
  security_admin_configuration_name = "secadmin-baseline"
  admin_rule_collection_name        = "rulecoll-baseline"

  admin_rules = [
    {
      name                             = "deny-rdp-ssh-from-internet"
      action                           = "Deny"
      direction                        = "Inbound"
      priority                         = 100
      protocol                         = "Tcp"
      source_address_prefix_type       = "ServiceTag"
      source_address_prefix           = "Internet"
      destination_address_prefix_type = "IPPrefix"
      destination_address_prefix      = "*"
      source_port_ranges               = ["0-65535"]
      destination_port_ranges          = ["22", "3389"]
    },
  ]

  tags = var.tags
}
