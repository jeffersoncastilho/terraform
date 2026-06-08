resource "azurerm_traffic_manager_profile" "this" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.routing_method

  dns_config {
    relative_name = var.dns_relative_name
    ttl           = var.ttl
  }

  monitor_config {
    protocol                     = var.probe_protocol
    port                         = var.probe_port
    path                         = var.probe_path
    interval_in_seconds          = var.probe_interval_seconds
    timeout_in_seconds           = var.probe_timeout_seconds
    tolerated_number_of_failures = var.probe_tolerated_failures
  }

  tags = var.tags
}

resource "azurerm_traffic_manager_external_endpoint" "this" {
  for_each = { for ep in var.endpoints : ep.name => ep }

  name       = each.value.name
  profile_id = azurerm_traffic_manager_profile.this.id
  target     = each.value.target
  priority   = each.value.priority
  weight     = each.value.weight
}
