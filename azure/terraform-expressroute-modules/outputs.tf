output "id" {
  description = "ID do ExpressRoute Circuit"
  value       = azurerm_express_route_circuit.this.id
}

output "service_key" {
  description = "Chave repassada ao provedor de conectividade para provisionar o circuito físico"
  value       = azurerm_express_route_circuit.this.service_key
  sensitive   = true
}
