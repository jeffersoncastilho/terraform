# ── Data Sources ───────────────────────────────────────────────────────────────

data "azurerm_resource_group" "workload_brazilsouth" {
  name = "rg-blog-castilho-workload-brazilsouth"
}

data "azurerm_resource_group" "network_eastus" {
  name = "rg-blog-castilho-network-eastus"
}

data "azurerm_subnet" "data_brazilsouth" {
  name                 = "snet-data"
  virtual_network_name = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name  = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_subnet" "data_eastus" {
  name                 = "snet-data"
  virtual_network_name = "vnet-spoke-blog-castilho-eastus"
  resource_group_name  = "rg-blog-castilho-network-eastus"
}

data "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "rg-blog-castilho-network-brazilsouth"
}

# ── Storage Account Primary (Brazil South — RAGZRS) ────────────────────────────

module "storage_primary" {
  source              = "../../terraform-storage-modules"
  name                = "stblogcastilhobrazil"
  resource_group_name = data.azurerm_resource_group.workload_brazilsouth.name
  location            = data.azurerm_resource_group.workload_brazilsouth.location
  replication_type    = var.primary_replication_type
  public_network_access_enabled = false
  containers          = ["data", "backups", "asr-cache"]
  private_endpoints = [
    {
      name                 = "pep-blob-st-blog-castilho-brazilsouth"
      resource_group_name  = data.azurerm_resource_group.workload_brazilsouth.name
      location             = data.azurerm_resource_group.workload_brazilsouth.location
      subnet_id            = data.azurerm_subnet.data_brazilsouth.id
      subresource          = "blob"
      private_dns_zone_ids = [data.azurerm_private_dns_zone.blob.id]
    },
    {
      name                 = "pep-blob-st-blog-castilho-eastus"
      resource_group_name  = "rg-blog-castilho-workload-eastus"
      location             = "eastus"
      subnet_id            = data.azurerm_subnet.data_eastus.id
      subresource          = "blob"
      private_dns_zone_ids = [data.azurerm_private_dns_zone.blob.id]
    },
  ]
  tags = var.tags
}

# ── Storage Account Cache (East US — LRS, para ASR cache) ─────────────────────

module "storage_cache" {
  source              = "../../terraform-storage-modules"
  name                = "stblogcastilhocache"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  replication_type    = "LRS"
  tags                = var.tags
}
