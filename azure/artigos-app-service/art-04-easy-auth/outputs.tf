# Outputs de art-04-easy-auth

output "app_name" {
  description = "Nome do Web App com Easy Auth habilitado"
  value       = azurerm_linux_web_app.easy_auth.name
}

output "default_hostname" {
  description = "Hostname público do Web App"
  value       = azurerm_linux_web_app.easy_auth.default_hostname
}
