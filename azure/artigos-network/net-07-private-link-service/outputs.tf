output "private_link_service_alias" {
  value = module.pls.alias
}

output "private_endpoint_connection_status" {
  value = module.private_endpoint.private_ip_address
}
