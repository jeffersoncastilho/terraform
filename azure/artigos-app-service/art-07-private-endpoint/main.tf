# Private Endpoint no App Service (Premium v3), sem exposição pública
# Série: artigos-app-service | Artigo: art-07-private-endpoint
#
# Private Endpoint exige tier Premium (ou Isolated) — por isso este artigo
# provisiona seu próprio App Service Plan, diferente da maioria dos outros
# artigos da série que reaproveitam o plano B1 do art-01.

locals {
  workload    = "app-service"
  name_suffix = "blog-castilho-eus"
}

data "azurerm_resource_group" "app_service" {
  name = "rg-${local.workload}-${local.name_suffix}"
}

resource "random_string" "app_suffix" {
  length  = 6
  special = false
  upper   = false
}

# ── VNet com subnet dedicada ao Private Endpoint ─────────────────────────────

module "vnet" {
  source              = "../../terraform-virtual-network-modules"
  name                = "vnet-pe-${local.name_suffix}"
  resource_group_name = data.azurerm_resource_group.app_service.name
  location            = data.azurerm_resource_group.app_service.location
  address_space       = ["10.20.0.0/24"]

  subnets = [
    { key = "pe", name = "snet-pe-${local.name_suffix}", address_prefixes = ["10.20.0.0/26"] },
  ]

  tags = var.tags
}

resource "azurerm_subnet" "pe_policies" {
  name                              = module.vnet.subnets["pe"].name
  resource_group_name               = data.azurerm_resource_group.app_service.name
  virtual_network_name              = module.vnet.vnet_name
  address_prefixes                  = ["10.20.0.0/26"]
  private_endpoint_network_policies = "Disabled"

  lifecycle {
    ignore_changes = [name]
  }
}

# ── App Service Plan Premium v3 + Web App (sem acesso público) ───────────────

resource "azurerm_service_plan" "premium" {
  name                = "plan-pe-${local.name_suffix}"
  resource_group_name = data.azurerm_resource_group.app_service.name
  location            = data.azurerm_resource_group.app_service.location
  os_type             = "Linux"
  sku_name            = "P1v3"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "private" {
  name                          = "app-private-blog-castilho-${random_string.app_suffix.result}"
  resource_group_name          = data.azurerm_resource_group.app_service.name
  location                      = data.azurerm_resource_group.app_service.location
  service_plan_id                = azurerm_service_plan.premium.id
  https_only                    = true
  public_network_access_enabled  = false
  tags                           = var.tags

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}

# ── Private Endpoint ──────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "app" {
  name                = "pe-app-${local.name_suffix}"
  resource_group_name = data.azurerm_resource_group.app_service.name
  location            = data.azurerm_resource_group.app_service.location
  subnet_id           = azurerm_subnet.pe_policies.id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-app-${local.name_suffix}"
    private_connection_resource_id = azurerm_linux_web_app.private.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [module.private_dns_zone.id]
  }
}

# ── Private DNS Zone + link com a VNet ───────────────────────────────────────

module "private_dns_zone" {
  source              = "../../terraform-private-dns-zone-modules"
  zone_name           = "privatelink.azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.app_service.name
  vnet_links = {
    pe = module.vnet.vnet_id
  }
  tags = var.tags
}
