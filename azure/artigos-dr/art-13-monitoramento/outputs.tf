output "law_brazilsouth_id" {
  description = "ID do Log Analytics Workspace Brazil South"
  value       = module.law_brazilsouth.workspace_id
}

output "law_eastus_id" {
  description = "ID do Log Analytics Workspace East US"
  value       = module.law_eastus.workspace_id
}

output "action_group_critico_id" {
  description = "ID do Action Group critico"
  value       = azurerm_monitor_action_group.critico.id
}

output "action_group_aviso_id" {
  description = "ID do Action Group aviso"
  value       = azurerm_monitor_action_group.aviso.id
}
