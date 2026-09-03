# Azure Virtual Network Manager: topologia (mesh) e regra de segurança admin
# centralizadas sobre 3 VNets de exemplo (frontend / backend / shared).
# Série: artigos-network | Artigo: net-01-vnet-manager

resource "azurerm_resource_group" "network_manager" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ── VNets de exemplo ("times/apps" que o Network Manager vai governar) ────────

resource "azurerm_virtual_network" "this" {
  for_each = var.vnets

  name                = "vnet-${each.key}-blog-castilho"
  resource_group_name = azurerm_resource_group.network_manager.name
  location            = azurerm_resource_group.network_manager.location
  address_space       = [each.value.address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.vnets

  name                 = "snet-${each.key}"
  resource_group_name  = azurerm_resource_group.network_manager.name
  virtual_network_name = azurerm_virtual_network.this[each.key].name
  address_prefixes     = [each.value.subnet_prefix]
}

# ── Azure Virtual Network Manager ──────────────────────────────────────────────

resource "azurerm_network_manager" "this" {
  name                = "avnm-blog-castilho"
  location            = azurerm_resource_group.network_manager.location
  resource_group_name = azurerm_resource_group.network_manager.name
  scope_accesses      = ["Connectivity", "SecurityAdmin"]

  scope {
    subscription_ids = ["/subscriptions/${var.subscription_id}"]
  }

  tags = var.tags
}

# Grupo de rede: as 3 VNets de exemplo, associadas como membros estáticos
resource "azurerm_network_manager_network_group" "app_vnets" {
  name               = "ng-app-vnets"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_static_member" "app_vnets" {
  for_each = var.vnets

  name                      = "member-${each.key}"
  network_group_id         = azurerm_network_manager_network_group.app_vnets.id
  target_virtual_network_id = azurerm_virtual_network.this[each.key].id
}

# ── Connectivity Configuration: topologia mesh entre as 3 VNets ──────────────
# O Network Manager cria e mantém o peering entre todas elas automaticamente —
# sem precisar declarar azurerm_virtual_network_peering para cada par.

resource "azurerm_network_manager_connectivity_configuration" "mesh" {
  name                  = "conn-mesh-app-vnets"
  network_manager_id   = azurerm_network_manager.this.id
  connectivity_topology = "Mesh"

  applies_to_group {
    group_connectivity  = "None"
    network_group_id   = azurerm_network_manager_network_group.app_vnets.id
  }
}

# ── Security Admin Configuration: regra que se aplica a TODAS as VNets do
# grupo, com prioridade acima de qualquer NSG local — bloqueia RDP/SSH vindos
# da Internet mesmo que alguém esqueça de configurar o NSG numa VNet nova.

resource "azurerm_network_manager_security_admin_configuration" "baseline" {
  name                = "secadmin-baseline"
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_admin_rule_collection" "baseline" {
  name                            = "rulecoll-baseline"
  security_admin_configuration_id = azurerm_network_manager_security_admin_configuration.baseline.id
  network_group_ids               = [azurerm_network_manager_network_group.app_vnets.id]
}

resource "azurerm_network_manager_admin_rule" "deny_rdp_ssh_internet" {
  name                     = "deny-rdp-ssh-from-internet"
  admin_rule_collection_id = azurerm_network_manager_admin_rule_collection.baseline.id
  action                   = "Deny"
  direction                = "Inbound"
  priority                 = 100

  protocol = "Tcp"

  source {
    address_prefix_type = "ServiceTag"
    address_prefix      = "Internet"
  }

  destination {
    address_prefix_type = "IPPrefix"
    address_prefix      = "*"
  }

  source_port_ranges      = ["0-65535"]
  destination_port_ranges = ["22", "3389"]
}

# ── Deployment: aplica as duas configurações na região ────────────────────────

resource "azurerm_network_manager_deployment" "connectivity" {
  network_manager_id = azurerm_network_manager.this.id
  location            = azurerm_resource_group.network_manager.location
  scope_access        = "Connectivity"
  configuration_ids   = [azurerm_network_manager_connectivity_configuration.mesh.id]
}

resource "azurerm_network_manager_deployment" "security_admin" {
  network_manager_id = azurerm_network_manager.this.id
  location            = azurerm_resource_group.network_manager.location
  scope_access        = "SecurityAdmin"
  configuration_ids   = [azurerm_network_manager_security_admin_configuration.baseline.id]

  depends_on = [azurerm_network_manager_admin_rule.deny_rdp_ssh_internet]
}
