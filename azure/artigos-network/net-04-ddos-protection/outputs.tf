output "ddos_plan_id" {
  value = module.ddos_plan.id
}

output "protected_public_ip" {
  value = module.pip_protected.ip_address
}
