resource "azurerm_public_ip" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  location             = var.location
  allocation_method    = var.allocation_method
  sku                  = var.sku
  zones                = var.zones
  ddos_protection_mode = var.ddos_protection_mode
  tags                 = var.tags
}
