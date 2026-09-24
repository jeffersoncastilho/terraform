resource "azurerm_virtual_network" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != null ? [1] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
}

resource "azurerm_subnet" "this" {
  for_each = { for s in var.subnets : s.key => s }

  name                                           = each.value.name
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.this.name
  address_prefixes                               = each.value.address_prefixes
  private_endpoint_network_policies              = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled  = each.value.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation_name
        actions = delegation.value.service_delegation_actions
      }
    }
  }
}
