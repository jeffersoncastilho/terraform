output "vault_id" {
  description = "ID do Recovery Services Vault"
  value       = module.site_recovery.vault_id
}

output "vault_name" {
  description = "Nome do Recovery Services Vault"
  value       = module.site_recovery.vault_name
}

output "replication_policy_id" {
  description = "ID da Replication Policy"
  value       = module.site_recovery.replication_policy_id
}

output "vm_id" {
  description = "ID da VM de teste (Brazil South)"
  value       = module.vm_brazilsouth.vm_id
}

output "vm_private_ip" {
  description = "IP privado da VM de teste"
  value       = module.vm_brazilsouth.private_ip_address
}
