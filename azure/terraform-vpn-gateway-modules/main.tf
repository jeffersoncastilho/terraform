resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = "Vpn"
  vpn_type            = var.vpn_type
  sku                 = var.sku
  generation          = var.generation

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration != null ? [var.vpn_client_configuration] : []
    content {
      address_space         = vpn_client_configuration.value.address_space
      vpn_client_protocols  = vpn_client_configuration.value.vpn_client_protocols
      vpn_auth_types        = vpn_client_configuration.value.vpn_auth_types

      dynamic "root_certificate" {
        for_each = vpn_client_configuration.value.root_certificates
        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }
    }
  }

  tags = var.tags
}
