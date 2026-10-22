# Referencia o Network Watcher que o Azure já cria automaticamente
# (NetworkWatcher_<região>, no resource group NetworkWatcherRG) assim que a
# primeira VNet de uma subscription é criada — não tenta criar um novo, o que
# causaria conflito na maioria das subscriptions.
#
# Usa VNet Flow Log (target_resource_id = VNet), não NSG Flow Log: NSG Flow
# Logs pararam de aceitar criação nova em 30/06/2025 (aposentadoria total em
# 30/09/2027).

resource "azurerm_network_watcher_flow_log" "this" {
  name                 = var.name
  network_watcher_name = "NetworkWatcher_${var.location}"
  resource_group_name  = "NetworkWatcherRG"
  target_resource_id   = var.target_resource_id
  storage_account_id   = var.storage_account_id
  enabled              = true
  version              = 2

  retention_policy {
    enabled = true
    days    = var.retention_days
  }

  dynamic "traffic_analytics" {
    for_each = var.traffic_analytics_workspace_id != null ? [1] : []
    content {
      enabled               = true
      workspace_id          = var.traffic_analytics_workspace_id
      workspace_region      = var.traffic_analytics_workspace_region
      workspace_resource_id = var.traffic_analytics_workspace_resource_id
      interval_in_minutes   = var.traffic_analytics_interval_minutes
    }
  }

  tags = var.tags
}
