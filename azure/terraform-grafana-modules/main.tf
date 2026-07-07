resource "azurerm_dashboard_grafana" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  grafana_major_version         = var.grafana_major_version
  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "monitoring_reader" {
  scope                = var.monitoring_scope
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.this.identity[0].principal_id
}
