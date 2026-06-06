output "firewall_brazilsouth" {
  description = "Azure Firewall — Brazil South"
  value = {
    id         = module.firewall_brazilsouth.firewall_id
    name       = module.firewall_brazilsouth.firewall_name
    private_ip = module.firewall_brazilsouth.private_ip_address
    public_ip  = module.firewall_brazilsouth.public_ip_address
    policy_id  = module.firewall_brazilsouth.policy_id
  }
}

output "firewall_eastus" {
  description = "Azure Firewall — East US"
  value = {
    id         = module.firewall_eastus.firewall_id
    name       = module.firewall_eastus.firewall_name
    private_ip = module.firewall_eastus.private_ip_address
    public_ip  = module.firewall_eastus.public_ip_address
    policy_id  = module.firewall_eastus.policy_id
  }
}

output "route_tables" {
  description = "Route Tables criadas"
  value = {
    brazilsouth = module.route_table_brazilsouth.route_table_id
    eastus      = module.route_table_eastus.route_table_id
  }
}

output "nsgs" {
  description = "Network Security Groups criados"
  value = {
    frontend_brazilsouth = module.nsg_frontend_brazilsouth.nsg_id
    frontend_eastus      = module.nsg_frontend_eastus.nsg_id
    backend_brazilsouth  = module.nsg_backend_brazilsouth.nsg_id
    backend_eastus       = module.nsg_backend_eastus.nsg_id
    data_brazilsouth     = module.nsg_data_brazilsouth.nsg_id
    data_eastus          = module.nsg_data_eastus.nsg_id
    aks_brazilsouth      = module.nsg_aks_brazilsouth.nsg_id
    aks_eastus           = module.nsg_aks_eastus.nsg_id
  }
}
