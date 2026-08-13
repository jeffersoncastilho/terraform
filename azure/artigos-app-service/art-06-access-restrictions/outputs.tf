# Outputs de art-06-access-restrictions

output "app_name" {
  description = "Nome do Web App com Access Restrictions habilitadas"
  value       = azurerm_linux_web_app.restricted.name
}

output "restricted_subnet_id" {
  description = "ID da subnet usada na restrição por VNet"
  value       = module.vnet.subnets["restricted"].id
}
