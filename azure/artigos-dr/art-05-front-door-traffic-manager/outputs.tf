output "front_door_endpoint" {
  description = "Hostname do Front Door Endpoint"
  value       = module.front_door.endpoint_hostname
}

output "traffic_manager_fqdn" {
  description = "FQDN do Traffic Manager"
  value       = module.traffic_manager.fqdn
}
