resource "azurerm_virtual_network_peering" "a_to_b" {
  name                      = var.peering_a_name
  resource_group_name       = var.peering_a_rg
  virtual_network_name      = var.peering_a_vnet_name
  remote_virtual_network_id = var.peering_b_vnet_id
  allow_forwarded_traffic   = var.peering_a_allow_forwarded_traffic
  allow_gateway_transit     = var.peering_a_allow_gateway_transit
  use_remote_gateways       = var.peering_a_use_remote_gateways
}

resource "azurerm_virtual_network_peering" "b_to_a" {
  name                      = var.peering_b_name
  resource_group_name       = var.peering_b_rg
  virtual_network_name      = var.peering_b_vnet_name
  remote_virtual_network_id = var.peering_a_vnet_id
  allow_forwarded_traffic   = var.peering_b_allow_forwarded_traffic
  allow_gateway_transit     = var.peering_b_allow_gateway_transit
  use_remote_gateways       = var.peering_b_use_remote_gateways
}
