# ── Data Sources — Resource Groups ────────────────────────────────────────────

data "azurerm_resource_group" "network_brazilsouth" {
  name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_resource_group" "network_eastus" {
  name = "rg-blog-castilho-network-eastus"
}

# ── Data Sources — Subnets Hub (Firewall) ─────────────────────────────────────

data "azurerm_subnet" "afw_brazilsouth" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = "vnet-hub-blog-castilho-brazilsouth"
  resource_group_name  = data.azurerm_resource_group.network_brazilsouth.name
}

data "azurerm_subnet" "afw_eastus" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = "vnet-hub-blog-castilho-eastus"
  resource_group_name  = data.azurerm_resource_group.network_eastus.name
}

# ── Data Sources — Subnets Spoke Brazil South ─────────────────────────────────

data "azurerm_subnet" "frontend_brs" {
  name                 = "snet-frontend"
  virtual_network_name = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name  = data.azurerm_resource_group.network_brazilsouth.name
}

data "azurerm_subnet" "backend_brs" {
  name                 = "snet-backend"
  virtual_network_name = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name  = data.azurerm_resource_group.network_brazilsouth.name
}

data "azurerm_subnet" "data_brs" {
  name                 = "snet-data"
  virtual_network_name = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name  = data.azurerm_resource_group.network_brazilsouth.name
}

data "azurerm_subnet" "aks_brs" {
  name                 = "snet-aks"
  virtual_network_name = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name  = data.azurerm_resource_group.network_brazilsouth.name
}

# ── Data Sources — Subnets Spoke East US ──────────────────────────────────────

data "azurerm_subnet" "frontend_eus" {
  name                 = "snet-frontend"
  virtual_network_name = "vnet-spoke-blog-castilho-eastus"
  resource_group_name  = data.azurerm_resource_group.network_eastus.name
}

data "azurerm_subnet" "backend_eus" {
  name                 = "snet-backend"
  virtual_network_name = "vnet-spoke-blog-castilho-eastus"
  resource_group_name  = data.azurerm_resource_group.network_eastus.name
}

data "azurerm_subnet" "data_eus" {
  name                 = "snet-data"
  virtual_network_name = "vnet-spoke-blog-castilho-eastus"
  resource_group_name  = data.azurerm_resource_group.network_eastus.name
}

data "azurerm_subnet" "aks_eus" {
  name                 = "snet-aks"
  virtual_network_name = "vnet-spoke-blog-castilho-eastus"
  resource_group_name  = data.azurerm_resource_group.network_eastus.name
}

# ── Azure Firewall — Brazil South ─────────────────────────────────────────────

module "firewall_brazilsouth" {
  source              = "../../terraform-firewall-modules"
  name                = "afw-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  subnet_id           = data.azurerm_subnet.afw_brazilsouth.id
  sku                 = var.sku
  tags                = var.tags
}

# ── Azure Firewall — East US ──────────────────────────────────────────────────

module "firewall_eastus" {
  source              = "../../terraform-firewall-modules"
  name                = "afw-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  subnet_id           = data.azurerm_subnet.afw_eastus.id
  sku                 = var.sku
  tags                = var.tags
}

# ── Route Table — Brazil South ────────────────────────────────────────────────

module "route_table_brazilsouth" {
  source              = "../../terraform-route-table-modules"
  name                = "rt-spoke-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  routes = [
    {
      name                   = "route-default-to-firewall"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.firewall_brazilsouth.private_ip_address
    }
  ]
  subnet_ids = [
    data.azurerm_subnet.frontend_brs.id,
    data.azurerm_subnet.backend_brs.id,
    data.azurerm_subnet.data_brs.id,
    data.azurerm_subnet.aks_brs.id,
  ]
  tags       = var.tags
  depends_on = [module.firewall_brazilsouth]
}

# ── Route Table — East US ─────────────────────────────────────────────────────

module "route_table_eastus" {
  source              = "../../terraform-route-table-modules"
  name                = "rt-spoke-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  routes = [
    {
      name                   = "route-default-to-firewall"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.firewall_eastus.private_ip_address
    }
  ]
  subnet_ids = [
    data.azurerm_subnet.frontend_eus.id,
    data.azurerm_subnet.backend_eus.id,
    data.azurerm_subnet.data_eus.id,
    data.azurerm_subnet.aks_eus.id,
  ]
  tags       = var.tags
  depends_on = [module.firewall_eastus]
}

# ── NSG Frontend — Brazil South ───────────────────────────────────────────────

module "nsg_frontend_brazilsouth" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-frontend-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  subnet_id           = data.azurerm_subnet.frontend_brs.id
  security_rules = [
    { name = "allow-https-inbound", priority = 100,  direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "Internet",  destination_address_prefix = "VirtualNetwork" },
    { name = "allow-http-inbound",  priority = 110,  direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "80",  source_address_prefix = "Internet",  destination_address_prefix = "VirtualNetwork" },
    { name = "deny-all-inbound",    priority = 4096, direction = "Inbound", access = "Deny",  protocol = "*",   source_port_range = "*", destination_port_range = "*",   source_address_prefix = "*",         destination_address_prefix = "*" },
  ]
  tags = var.tags
}

# ── NSG Frontend — East US ────────────────────────────────────────────────────

module "nsg_frontend_eastus" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-frontend-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  subnet_id           = data.azurerm_subnet.frontend_eus.id
  security_rules = [
    { name = "allow-https-inbound", priority = 100,  direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "Internet",  destination_address_prefix = "VirtualNetwork" },
    { name = "allow-http-inbound",  priority = 110,  direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "80",  source_address_prefix = "Internet",  destination_address_prefix = "VirtualNetwork" },
    { name = "deny-all-inbound",    priority = 4096, direction = "Inbound", access = "Deny",  protocol = "*",   source_port_range = "*", destination_port_range = "*",   source_address_prefix = "*",         destination_address_prefix = "*" },
  ]
  tags = var.tags
}

# ── NSG Backend — Brazil South ────────────────────────────────────────────────

module "nsg_backend_brazilsouth" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-backend-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  subnet_id           = data.azurerm_subnet.backend_brs.id
  security_rules = [
    { name = "allow-frontend-inbound",  priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "8080", source_address_prefix = "10.2.1.0/24", destination_address_prefix = "VirtualNetwork" },
    { name = "deny-internet-inbound",   priority = 200, direction = "Inbound", access = "Deny",  protocol = "*",   source_port_range = "*", destination_port_range = "*",    source_address_prefix = "Internet",    destination_address_prefix = "*" },
  ]
  tags = var.tags
}

# ── NSG Backend — East US ─────────────────────────────────────────────────────

module "nsg_backend_eastus" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-backend-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  subnet_id           = data.azurerm_subnet.backend_eus.id
  security_rules = [
    { name = "allow-frontend-inbound",  priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "8080", source_address_prefix = "10.3.1.0/24", destination_address_prefix = "VirtualNetwork" },
    { name = "deny-internet-inbound",   priority = 200, direction = "Inbound", access = "Deny",  protocol = "*",   source_port_range = "*", destination_port_range = "*",    source_address_prefix = "Internet",    destination_address_prefix = "*" },
  ]
  tags = var.tags
}

# ── NSG Data — Brazil South ───────────────────────────────────────────────────

module "nsg_data_brazilsouth" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-data-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  subnet_id           = data.azurerm_subnet.data_brs.id
  security_rules = [
    { name = "allow-backend-sql", priority = 100,  direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "1433", source_address_prefix = "10.2.2.0/24", destination_address_prefix = "VirtualNetwork" },
    { name = "deny-all-inbound",  priority = 4096, direction = "Inbound", access = "Deny",  protocol = "*",   source_port_range = "*", destination_port_range = "*",    source_address_prefix = "*",           destination_address_prefix = "*" },
  ]
  tags = var.tags
}

# ── NSG Data — East US ────────────────────────────────────────────────────────

module "nsg_data_eastus" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-data-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  subnet_id           = data.azurerm_subnet.data_eus.id
  security_rules = [
    { name = "allow-backend-sql", priority = 100,  direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "1433", source_address_prefix = "10.3.2.0/24", destination_address_prefix = "VirtualNetwork" },
    { name = "deny-all-inbound",  priority = 4096, direction = "Inbound", access = "Deny",  protocol = "*",   source_port_range = "*", destination_port_range = "*",    source_address_prefix = "*",           destination_address_prefix = "*" },
  ]
  tags = var.tags
}

# ── NSG AKS — Brazil South ────────────────────────────────────────────────────

module "nsg_aks_brazilsouth" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-aks-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  subnet_id           = data.azurerm_subnet.aks_brs.id
  security_rules = [
    { name = "allow-lb-inbound", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "VirtualNetwork" },
  ]
  tags = var.tags
}

# ── NSG AKS — East US ─────────────────────────────────────────────────────────

module "nsg_aks_eastus" {
  source              = "../../terraform-nsg-modules"
  name                = "nsg-aks-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  subnet_id           = data.azurerm_subnet.aks_eus.id
  security_rules = [
    { name = "allow-lb-inbound", priority = 100, direction = "Inbound", access = "Allow", protocol = "Tcp", source_port_range = "*", destination_port_range = "443", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "VirtualNetwork" },
  ]
  tags = var.tags
}
