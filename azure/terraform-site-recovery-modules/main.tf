resource "azurerm_recovery_services_vault" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_site_recovery_fabric" "source" {
  name                = "fabric-${var.source_location}"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  location            = var.source_location
}

resource "azurerm_site_recovery_fabric" "target" {
  name                = "fabric-${var.target_location}"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  location            = var.target_location
}

resource "azurerm_site_recovery_protection_container" "source" {
  name                 = "container-${var.source_location}"
  resource_group_name  = var.resource_group_name
  recovery_vault_name  = azurerm_recovery_services_vault.this.name
  recovery_fabric_name = azurerm_site_recovery_fabric.source.name
}

resource "azurerm_site_recovery_protection_container" "target" {
  name                 = "container-${var.target_location}"
  resource_group_name  = var.resource_group_name
  recovery_vault_name  = azurerm_recovery_services_vault.this.name
  recovery_fabric_name = azurerm_site_recovery_fabric.target.name
}

resource "azurerm_site_recovery_replication_policy" "this" {
  name                                                 = "policy-${var.name}-${var.recovery_point_retention_minutes}min"
  resource_group_name                                  = var.resource_group_name
  recovery_vault_name                                  = azurerm_recovery_services_vault.this.name
  recovery_point_retention_in_minutes                  = var.recovery_point_retention_minutes
  application_consistent_snapshot_frequency_in_minutes = var.snapshot_frequency_minutes
}

resource "azurerm_site_recovery_protection_container_mapping" "this" {
  name                                      = "mapping-${var.source_location}-to-${var.target_location}"
  resource_group_name                       = var.resource_group_name
  recovery_vault_name                       = azurerm_recovery_services_vault.this.name
  recovery_fabric_name                      = azurerm_site_recovery_fabric.source.name
  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.source.name
  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.target.id
  recovery_replication_policy_id            = azurerm_site_recovery_replication_policy.this.id
}

resource "azurerm_site_recovery_network_mapping" "this" {
  name                        = "nm-${var.source_location}-to-${var.target_location}"
  resource_group_name         = var.resource_group_name
  recovery_vault_name         = azurerm_recovery_services_vault.this.name
  source_recovery_fabric_name = azurerm_site_recovery_fabric.source.name
  target_recovery_fabric_name = azurerm_site_recovery_fabric.target.name
  source_network_id           = var.source_network_id
  target_network_id           = var.target_network_id
}
