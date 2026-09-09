output "vpn_gateway_public_ip" {
  value = module.pip_vpn_gateway.ip_address
}

output "p2s_address_pool" {
  value = var.p2s_address_pool
}
