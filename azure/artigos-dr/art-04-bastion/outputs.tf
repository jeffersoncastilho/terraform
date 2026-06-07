output "bastion_brazilsouth_id" {
  description = "ID do Bastion Host BRS"
  value       = module.bastion_brazilsouth.bastion_id
}

output "bastion_eastus_id" {
  description = "ID do Bastion Host EUS"
  value       = module.bastion_eastus.bastion_id
}
