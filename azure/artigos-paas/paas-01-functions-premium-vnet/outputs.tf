output "function_app_default_hostname" {
  value = azurerm_linux_function_app.this.default_hostname
}

output "function_app_outbound_ips" {
  value = azurerm_linux_function_app.this.outbound_ip_addresses
}
