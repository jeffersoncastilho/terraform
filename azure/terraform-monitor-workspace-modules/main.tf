# Azure Monitor Workspace (destino do Managed Prometheus) + DCE/DCR
# A associação com o cluster (DCRA) é feita no ambiente, pois depende do AKS.

resource "azurerm_monitor_workspace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_monitor_data_collection_endpoint" "this" {
  count               = var.create_dcr ? 1 : 0
  name                = "dce-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
  tags                = var.tags
}

resource "azurerm_monitor_data_collection_rule" "this" {
  count                       = var.create_dcr ? 1 : 0
  name                        = "dcr-${var.name}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.this[0].id
  kind                        = "Linux"
  tags                        = var.tags

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.this.id
      name               = "MonitoringAccount1"
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount1"]
  }

  data_sources {
    prometheus_forwarder {
      streams = ["Microsoft-PrometheusMetrics"]
      name    = "PrometheusDataSource"
    }
  }
}
