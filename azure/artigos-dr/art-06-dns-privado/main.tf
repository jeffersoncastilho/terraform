# ── Data Sources — Virtual Networks ───────────────────────────────────────────

data "azurerm_resource_group" "network_brazilsouth" {
  name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_virtual_network" "hub_brazilsouth" {
  name                = "vnet-hub-blog-castilho-brazilsouth"
  resource_group_name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_virtual_network" "hub_eastus" {
  name                = "vnet-hub-blog-castilho-eastus"
  resource_group_name = "rg-blog-castilho-network-eastus"
}

data "azurerm_virtual_network" "spoke_brazilsouth" {
  name                = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_virtual_network" "spoke_eastus" {
  name                = "vnet-spoke-blog-castilho-eastus"
  resource_group_name = "rg-blog-castilho-network-eastus"
}

# ── Locals ─────────────────────────────────────────────────────────────────────

locals {
  vnet_links = {
    hub-brazilsouth   = data.azurerm_virtual_network.hub_brazilsouth.id
    hub-eastus        = data.azurerm_virtual_network.hub_eastus.id
    spoke-brazilsouth = data.azurerm_virtual_network.spoke_brazilsouth.id
    spoke-eastus      = data.azurerm_virtual_network.spoke_eastus.id
  }

  zones = [
    "privatelink.blob.core.windows.net",
    "privatelink.database.windows.net",
    "privatelink.azurecr.io",
    "privatelink.vaultcore.azure.net",
    "privatelink.monitor.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "blog-castilho.internal",
  ]
}

# ── Private DNS Zones + VNet Links ────────────────────────────────────────────

module "dns_zones" {
  source   = "../../terraform-private-dns-zone-modules"
  for_each = toset(local.zones)

  zone_name           = each.value
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  vnet_links          = local.vnet_links
  tags                = var.tags
}
