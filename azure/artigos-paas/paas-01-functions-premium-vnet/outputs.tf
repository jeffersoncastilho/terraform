output "function_app_default_hostname" {
  value = module.functions.default_hostname
}

output "function_app_outbound_ips" {
  value = module.functions.outbound_ip_addresses
}
