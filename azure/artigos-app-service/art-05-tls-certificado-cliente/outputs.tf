# Outputs de art-05-tls-certificado-cliente

output "app_name" {
  description = "Nome do Web App com TLS 1.2 e mTLS habilitados"
  value       = azurerm_linux_web_app.mtls.name
}

output "default_hostname" {
  description = "Hostname público do Web App"
  value       = azurerm_linux_web_app.mtls.default_hostname
}
