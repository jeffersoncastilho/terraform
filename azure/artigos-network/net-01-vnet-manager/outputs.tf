output "network_manager_id" {
  value = module.network_manager.id
}

output "network_group_id" {
  value = module.network_manager.network_group_id
}

output "vnet_ids" {
  value = { for k, v in module.vnets : k => v.vnet_id }
}
