output "id" {
  value = azurerm_linux_function_app.this.id
}

output "default_hostname" {
  value = azurerm_linux_function_app.this.default_hostname
}

output "outbound_ip_addresses" {
  value = azurerm_linux_function_app.this.outbound_ip_addresses
}

output "plan_id" {
  value = azurerm_service_plan.this.id
}
