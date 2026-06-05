# ── Resource Groups ───────────────────────────────────────────────────────────

module "rg_network_brazilsouth" {
  source          = "../../terraform-resource-group-modules"
  resource_type   = "rg"
  project_name    = "blog-castilho-network"
  environment     = ""
  location_suffix = "brazilsouth"
  location        = "brazilsouth"
  tags            = var.tags
}

module "rg_network_eastus" {
  source          = "../../terraform-resource-group-modules"
  resource_type   = "rg"
  project_name    = "blog-castilho-network"
  environment     = ""
  location_suffix = "eastus"
  location        = "eastus"
  tags            = var.tags
}

module "rg_workload_brazilsouth" {
  source          = "../../terraform-resource-group-modules"
  resource_type   = "rg"
  project_name    = "blog-castilho-workload"
  environment     = ""
  location_suffix = "brazilsouth"
  location        = "brazilsouth"
  tags            = var.tags
}

module "rg_workload_eastus" {
  source          = "../../terraform-resource-group-modules"
  resource_type   = "rg"
  project_name    = "blog-castilho-workload"
  environment     = ""
  location_suffix = "eastus"
  location        = "eastus"
  tags            = var.tags
}

# ── Hub VNet — Brazil South ───────────────────────────────────────────────────

module "vnet_hub_brazilsouth" {
  source              = "../../terraform-virtual-network-modules"
  name                = "vnet-hub-blog-castilho-brazilsouth"
  resource_group_name = module.rg_network_brazilsouth.name
  location            = "brazilsouth"
  address_space       = ["10.0.0.0/16"]

  subnets = [
    { key = "firewall",   name = "AzureFirewallSubnet", address_prefixes = ["10.0.0.0/26"] },
    { key = "gateway",    name = "GatewaySubnet",       address_prefixes = ["10.0.0.64/27"] },
    { key = "bastion",    name = "AzureBastionSubnet",  address_prefixes = ["10.0.0.128/26"] },
    { key = "management", name = "snet-management",     address_prefixes = ["10.0.0.192/27"] },
  ]

  tags       = var.tags
  depends_on = [module.rg_network_brazilsouth]
}

# ── Hub VNet — East US ────────────────────────────────────────────────────────

module "vnet_hub_eastus" {
  source              = "../../terraform-virtual-network-modules"
  name                = "vnet-hub-blog-castilho-eastus"
  resource_group_name = module.rg_network_eastus.name
  location            = "eastus"
  address_space       = ["10.1.0.0/16"]

  subnets = [
    { key = "firewall",   name = "AzureFirewallSubnet", address_prefixes = ["10.1.0.0/26"] },
    { key = "gateway",    name = "GatewaySubnet",       address_prefixes = ["10.1.0.64/27"] },
    { key = "bastion",    name = "AzureBastionSubnet",  address_prefixes = ["10.1.0.128/26"] },
    { key = "management", name = "snet-management",     address_prefixes = ["10.1.0.192/27"] },
  ]

  tags       = var.tags
  depends_on = [module.rg_network_eastus]
}

# ── Spoke VNet — Brazil South ─────────────────────────────────────────────────

module "vnet_spoke_brazilsouth" {
  source              = "../../terraform-virtual-network-modules"
  name                = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name = module.rg_network_brazilsouth.name
  location            = "brazilsouth"
  address_space       = ["10.2.0.0/16"]

  subnets = [
    { key = "frontend", name = "snet-frontend", address_prefixes = ["10.2.1.0/24"] },
    { key = "backend",  name = "snet-backend",  address_prefixes = ["10.2.2.0/24"] },
    { key = "data",     name = "snet-data",     address_prefixes = ["10.2.3.0/24"] },
    { key = "aks",      name = "snet-aks",      address_prefixes = ["10.2.4.0/22"] },
  ]

  tags       = var.tags
  depends_on = [module.rg_network_brazilsouth]
}

# ── Spoke VNet — East US ──────────────────────────────────────────────────────

module "vnet_spoke_eastus" {
  source              = "../../terraform-virtual-network-modules"
  name                = "vnet-spoke-blog-castilho-eastus"
  resource_group_name = module.rg_network_eastus.name
  location            = "eastus"
  address_space       = ["10.3.0.0/16"]

  subnets = [
    { key = "frontend", name = "snet-frontend", address_prefixes = ["10.3.1.0/24"] },
    { key = "backend",  name = "snet-backend",  address_prefixes = ["10.3.2.0/24"] },
    { key = "data",     name = "snet-data",     address_prefixes = ["10.3.3.0/24"] },
    { key = "aks",      name = "snet-aks",      address_prefixes = ["10.3.4.0/22"] },
  ]

  tags       = var.tags
  depends_on = [module.rg_network_eastus]
}

# ── Peering Hub-Hub (Global) ──────────────────────────────────────────────────

module "peering_hub_hub" {
  source = "../../terraform-vnet-peering-modules"

  peering_a_name                    = "peer-hub-brazilsouth-to-hub-eastus"
  peering_a_rg                      = module.vnet_hub_brazilsouth.resource_group_name
  peering_a_vnet_name               = module.vnet_hub_brazilsouth.vnet_name
  peering_a_vnet_id                 = module.vnet_hub_brazilsouth.vnet_id
  peering_a_allow_forwarded_traffic = true

  peering_b_name                    = "peer-hub-eastus-to-hub-brazilsouth"
  peering_b_rg                      = module.vnet_hub_eastus.resource_group_name
  peering_b_vnet_name               = module.vnet_hub_eastus.vnet_name
  peering_b_vnet_id                 = module.vnet_hub_eastus.vnet_id
  peering_b_allow_forwarded_traffic = true

  depends_on = [module.vnet_hub_brazilsouth, module.vnet_hub_eastus]
}

# ── Peering Hub-Spoke — Brazil South ─────────────────────────────────────────

module "peering_hub_spoke_brazilsouth" {
  source = "../../terraform-vnet-peering-modules"

  peering_a_name                    = "peer-hub-to-spoke-brazilsouth"
  peering_a_rg                      = module.vnet_hub_brazilsouth.resource_group_name
  peering_a_vnet_name               = module.vnet_hub_brazilsouth.vnet_name
  peering_a_vnet_id                 = module.vnet_hub_brazilsouth.vnet_id
  peering_a_allow_forwarded_traffic = true
  peering_a_allow_gateway_transit   = true

  peering_b_name                    = "peer-spoke-to-hub-brazilsouth"
  peering_b_rg                      = module.vnet_spoke_brazilsouth.resource_group_name
  peering_b_vnet_name               = module.vnet_spoke_brazilsouth.vnet_name
  peering_b_vnet_id                 = module.vnet_spoke_brazilsouth.vnet_id
  peering_b_allow_forwarded_traffic = true
  peering_b_use_remote_gateways     = false

  depends_on = [module.vnet_hub_brazilsouth, module.vnet_spoke_brazilsouth]
}

# ── Peering Hub-Spoke — East US ───────────────────────────────────────────────

module "peering_hub_spoke_eastus" {
  source = "../../terraform-vnet-peering-modules"

  peering_a_name                    = "peer-hub-to-spoke-eastus"
  peering_a_rg                      = module.vnet_hub_eastus.resource_group_name
  peering_a_vnet_name               = module.vnet_hub_eastus.vnet_name
  peering_a_vnet_id                 = module.vnet_hub_eastus.vnet_id
  peering_a_allow_forwarded_traffic = true
  peering_a_allow_gateway_transit   = true

  peering_b_name                    = "peer-spoke-to-hub-eastus"
  peering_b_rg                      = module.vnet_spoke_eastus.resource_group_name
  peering_b_vnet_name               = module.vnet_spoke_eastus.vnet_name
  peering_b_vnet_id                 = module.vnet_spoke_eastus.vnet_id
  peering_b_allow_forwarded_traffic = true
  peering_b_use_remote_gateways     = false

  depends_on = [module.vnet_hub_eastus, module.vnet_spoke_eastus]
}
