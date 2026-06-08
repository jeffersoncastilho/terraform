output "resource_groups" {
  description = "Resource groups criados"
  value = {
    network_brazilsouth  = module.rg_network_brazilsouth.name
    network_eastus       = module.rg_network_eastus.name
    workload_brazilsouth = module.rg_workload_brazilsouth.name
    workload_eastus      = module.rg_workload_eastus.name
  }
}

output "vnet_hub_brazilsouth" {
  description = "Hub VNet — Brazil South"
  value = {
    id                  = module.vnet_hub_brazilsouth.vnet_id
    name                = module.vnet_hub_brazilsouth.vnet_name
    resource_group_name = module.vnet_hub_brazilsouth.resource_group_name
  }
}

output "vnet_hub_eastus" {
  description = "Hub VNet — East US"
  value = {
    id                  = module.vnet_hub_eastus.vnet_id
    name                = module.vnet_hub_eastus.vnet_name
    resource_group_name = module.vnet_hub_eastus.resource_group_name
  }
}

output "vnet_spoke_brazilsouth" {
  description = "Spoke VNet — Brazil South"
  value = {
    id                  = module.vnet_spoke_brazilsouth.vnet_id
    name                = module.vnet_spoke_brazilsouth.vnet_name
    resource_group_name = module.vnet_spoke_brazilsouth.resource_group_name
  }
}

output "vnet_spoke_eastus" {
  description = "Spoke VNet — East US"
  value = {
    id                  = module.vnet_spoke_eastus.vnet_id
    name                = module.vnet_spoke_eastus.vnet_name
    resource_group_name = module.vnet_spoke_eastus.resource_group_name
  }
}
