# ── Data Sources ───────────────────────────────────────────────────────────────

data "azurerm_resource_group" "network_brazilsouth" {
  name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_public_ip" "firewall_brazilsouth" {
  name                = "pip-afw-blog-castilho-brazilsouth"
  resource_group_name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_public_ip" "firewall_eastus" {
  name                = "pip-afw-blog-castilho-eastus"
  resource_group_name = "rg-blog-castilho-network-eastus"
}

# ── Azure Front Door ──────────────────────────────────────────────────────────

module "front_door" {
  source              = "../../terraform-front-door-modules"
  name                = "afd-blog-castilho"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  sku                 = "Premium_AzureFrontDoor"
  waf_policy_name     = "wafblogcastilho"
  waf_mode            = var.waf_mode
  endpoint_name       = "ep-blog-castilho"
  origin_group_name   = "og-blog-castilho"
  route_name          = "route-blog-castilho"
  security_policy_name = "secpolicy-blog-castilho"
  origins = [
    {
      name      = "origin-brazilsouth"
      host_name = data.azurerm_public_ip.firewall_brazilsouth.ip_address
      priority  = 1
      weight    = 1000
    },
    {
      name      = "origin-eastus"
      host_name = data.azurerm_public_ip.firewall_eastus.ip_address
      priority  = 2
      weight    = 1000
    },
  ]
  tags = var.tags
}

# ── Traffic Manager ───────────────────────────────────────────────────────────

module "traffic_manager" {
  source              = "../../terraform-traffic-manager-modules"
  name                = "tm-blog-castilho"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  routing_method      = "Priority"
  dns_relative_name   = "tm-blog-castilho"
  ttl                 = var.tm_ttl
  endpoints = [
    {
      name     = "endpoint-brazilsouth"
      target   = data.azurerm_public_ip.firewall_brazilsouth.ip_address
      priority = 1
      weight   = 100
    },
    {
      name     = "endpoint-eastus"
      target   = data.azurerm_public_ip.firewall_eastus.ip_address
      priority = 2
      weight   = 100
    },
  ]
  tags = var.tags
}
