resource "azurerm_lb" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = var.frontend_name
    subnet_id                     = var.frontend_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "this" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  name            = "probe-${var.protocol}"
  loadbalancer_id = azurerm_lb.this.id
  protocol        = var.protocol
  port            = var.port
}

resource "azurerm_lb_rule" "this" {
  name                           = "rule-${var.protocol}"
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = var.protocol
  frontend_port                  = var.port
  backend_port                   = var.port
  frontend_ip_configuration_name = var.frontend_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  probe_id                       = azurerm_lb_probe.this.id
}
