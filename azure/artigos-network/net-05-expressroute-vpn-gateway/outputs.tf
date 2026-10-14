output "vpn_gateway_public_ip" {
  value = module.pip_vpn_gateway.ip_address
}

output "expressroute_service_key" {
  value       = module.expressroute.service_key
  description = "Chave repassada ao provedor de conectividade para provisionar o circuito físico"
  sensitive   = true
}
