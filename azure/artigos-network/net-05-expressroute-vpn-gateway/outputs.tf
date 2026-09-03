output "vpn_gateway_public_ip" {
  value = azurerm_public_ip.vpn_gateway.ip_address
}

output "expressroute_service_key" {
  value       = azurerm_express_route_circuit.this.service_key
  description = "Chave repassada ao provedor de conectividade para provisionar o circuito físico"
  sensitive   = true
}
