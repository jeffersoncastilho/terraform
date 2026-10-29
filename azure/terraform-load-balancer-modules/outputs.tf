output "id" {
  description = "ID do Load Balancer"
  value       = azurerm_lb.this.id
}

output "frontend_ip_configuration_id" {
  description = "ID da configuração de frontend — usado como alvo de um Private Link Service"
  value       = azurerm_lb.this.frontend_ip_configuration[0].id
}

output "backend_address_pool_id" {
  description = "ID do backend pool"
  value       = azurerm_lb_backend_address_pool.this.id
}
