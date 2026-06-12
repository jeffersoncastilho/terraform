output "vm_id" {
  description = "ID da Máquina Virtual criada"
  value       = var.os_type == "linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
}

output "private_ip_address" {
  description = "Endereço IP privado da VM"
  value       = azurerm_network_interface.this.private_ip_address
}

output "nic_id" {
  description = "ID da Interface de Rede criada"
  value       = azurerm_network_interface.this.id
}

output "public_ip_address" {
  description = "Endereço IP público da VM (se habilitado)"
  value       = var.enable_public_ip ? azurerm_public_ip.this[0].ip_address : null
}