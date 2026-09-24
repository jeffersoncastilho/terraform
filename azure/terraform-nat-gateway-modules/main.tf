resource "azurerm_nat_gateway" "this" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = var.public_ip_address_id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = toset(var.subnet_ids)

  subnet_id      = each.value
  nat_gateway_id = azurerm_nat_gateway.this.id
}
