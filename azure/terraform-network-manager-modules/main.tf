resource "azurerm_network_manager" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  scope_accesses      = var.scope_accesses

  scope {
    subscription_ids = ["/subscriptions/${var.subscription_id}"]
  }

  tags = var.tags
}

# Grupo de rede: as VNets governadas, associadas como membros estáticos.
resource "azurerm_network_manager_network_group" "this" {
  name               = var.network_group_name
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_static_member" "this" {
  for_each = var.member_vnet_ids

  name                      = "member-${each.key}"
  network_group_id          = azurerm_network_manager_network_group.this.id
  target_virtual_network_id = each.value
}

# ── Connectivity Configuration: topologia entre as VNets do grupo ────────────
# O Network Manager cria e mantém o peering automaticamente — sem precisar
# declarar azurerm_virtual_network_peering para cada par.

resource "azurerm_network_manager_connectivity_configuration" "this" {
  count = var.enable_connectivity_configuration ? 1 : 0

  name                   = var.connectivity_configuration_name
  network_manager_id     = azurerm_network_manager.this.id
  connectivity_topology  = var.connectivity_topology

  applies_to_group {
    group_connectivity = "None"
    network_group_id   = azurerm_network_manager_network_group.this.id
  }
}

# ── Security Admin Configuration: regras que se aplicam a TODAS as VNets do
# grupo, com prioridade acima de qualquer NSG local.

resource "azurerm_network_manager_security_admin_configuration" "this" {
  count = length(var.admin_rules) > 0 ? 1 : 0

  name                = var.security_admin_configuration_name
  network_manager_id = azurerm_network_manager.this.id
}

resource "azurerm_network_manager_admin_rule_collection" "this" {
  count = length(var.admin_rules) > 0 ? 1 : 0

  name                             = var.admin_rule_collection_name
  security_admin_configuration_id  = azurerm_network_manager_security_admin_configuration.this[0].id
  network_group_ids                = [azurerm_network_manager_network_group.this.id]
}

resource "azurerm_network_manager_admin_rule" "this" {
  for_each = { for r in var.admin_rules : r.name => r }

  name                     = each.value.name
  admin_rule_collection_id = azurerm_network_manager_admin_rule_collection.this[0].id
  action                   = each.value.action
  direction                = each.value.direction
  priority                 = each.value.priority
  protocol                 = each.value.protocol

  source {
    address_prefix_type = each.value.source_address_prefix_type
    address_prefix       = each.value.source_address_prefix
  }

  destination {
    address_prefix_type = each.value.destination_address_prefix_type
    address_prefix       = each.value.destination_address_prefix
  }

  source_port_ranges      = each.value.source_port_ranges
  destination_port_ranges = each.value.destination_port_ranges
}

# ── Deployment: aplica as configurações na região ─────────────────────────────

resource "azurerm_network_manager_deployment" "connectivity" {
  count = var.enable_connectivity_configuration ? 1 : 0

  network_manager_id = azurerm_network_manager.this.id
  location            = var.location
  scope_access        = "Connectivity"
  configuration_ids   = [azurerm_network_manager_connectivity_configuration.this[0].id]
}

resource "azurerm_network_manager_deployment" "security_admin" {
  count = length(var.admin_rules) > 0 ? 1 : 0

  network_manager_id = azurerm_network_manager.this.id
  location            = var.location
  scope_access        = "SecurityAdmin"
  configuration_ids   = [azurerm_network_manager_security_admin_configuration.this[0].id]

  depends_on = [azurerm_network_manager_admin_rule.this]
}
