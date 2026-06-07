# ── Data Sources — Resource Groups ────────────────────────────────────────────

data "azurerm_resource_group" "network_brazilsouth" {
  name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_resource_group" "network_eastus" {
  name = "rg-blog-castilho-network-eastus"
}

# ── Data Sources — Subnets AzureBastionSubnet ─────────────────────────────────

data "azurerm_subnet" "bastion_brazilsouth" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = "vnet-hub-blog-castilho-brazilsouth"
  resource_group_name  = data.azurerm_resource_group.network_brazilsouth.name
}

data "azurerm_subnet" "bastion_eastus" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = "vnet-hub-blog-castilho-eastus"
  resource_group_name  = data.azurerm_resource_group.network_eastus.name
}

# ── Azure Bastion — Brazil South ──────────────────────────────────────────────

module "bastion_brazilsouth" {
  source              = "../../terraform-bastion-modules"
  name                = "bastion-hub-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  subnet_id           = data.azurerm_subnet.bastion_brazilsouth.id
  sku                 = var.sku
  scale_units         = var.scale_units
  tags                = var.tags
}

# ── Azure Bastion — East US ───────────────────────────────────────────────────

module "bastion_eastus" {
  source              = "../../terraform-bastion-modules"
  name                = "bastion-hub-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  subnet_id           = data.azurerm_subnet.bastion_eastus.id
  sku                 = var.sku
  scale_units         = var.scale_units
  tags                = var.tags
}
