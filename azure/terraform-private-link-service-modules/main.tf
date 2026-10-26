resource "azurerm_private_link_service" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  nat_ip_configuration {
    name      = "nat-primary"
    subnet_id = var.nat_subnet_id
    primary   = true
  }

  load_balancer_frontend_ip_configuration_ids = [
    var.load_balancer_frontend_ip_configuration_id,
  ]

  tags = var.tags
}
