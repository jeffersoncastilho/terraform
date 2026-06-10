# ── Data Sources ───────────────────────────────────────────────────────────────

data "azurerm_resource_group" "network_eastus" {
  name = "rg-blog-castilho-network-eastus"
}

data "azurerm_resource_group" "workload_brazilsouth" {
  name = "rg-blog-castilho-workload-brazilsouth"
}

data "azurerm_subnet" "backend_brazilsouth" {
  name                 = "snet-backend"
  virtual_network_name = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name  = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_virtual_network" "spoke_brazilsouth" {
  name                = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_virtual_network" "spoke_eastus" {
  name                = "vnet-spoke-blog-castilho-eastus"
  resource_group_name = "rg-blog-castilho-network-eastus"
}

# ── Recovery Services Vault — East US ─────────────────────────────────────────

module "site_recovery" {
  source              = "../../terraform-site-recovery-modules"
  name                = "rsv-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  sku                 = "Standard"
  source_location     = "brazilsouth"
  target_location     = data.azurerm_resource_group.network_eastus.location
  source_network_id   = data.azurerm_virtual_network.spoke_brazilsouth.id
  target_network_id   = data.azurerm_virtual_network.spoke_eastus.id
  recovery_point_retention_minutes = var.recovery_point_retention_minutes
  snapshot_frequency_minutes       = var.snapshot_frequency_minutes
  tags                = var.tags
}

# ── VM de Teste — Brazil South ─────────────────────────────────────────────────

module "vm_brazilsouth" {
  source              = "../../terraform-vm-azure-modules"
  vm_name             = "vm-blog-castilho-01"
  resource_group_name = data.azurerm_resource_group.workload_brazilsouth.name
  location            = data.azurerm_resource_group.workload_brazilsouth.location
  subnet_id           = data.azurerm_subnet.backend_brazilsouth.id
  vm_size             = "Standard_B2s"
  admin_username      = "azureuser"
  public_key          = var.ssh_public_key
  enable_public_ip    = false
  tags                = var.tags
}
