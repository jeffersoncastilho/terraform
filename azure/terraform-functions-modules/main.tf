resource "azurerm_service_plan" "this" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  service_plan_id            = azurerm_service_plan.this.id

  virtual_network_subnet_id = var.subnet_id

  site_config {
    vnet_route_all_enabled = var.subnet_id != null

    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = merge(
    var.subnet_id != null ? { "WEBSITE_VNET_ROUTE_ALL" = "1" } : {},
    var.app_settings,
  )

  tags = var.tags
}
