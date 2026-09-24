output "nat_gateway_public_ip" {
  value = module.pip_natgw.ip_address
}

output "container_group_name" {
  value = module.aci_test.name
}
