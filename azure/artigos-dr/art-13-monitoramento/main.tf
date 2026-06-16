# ── Data Sources — Resource Groups ────────────────────────────────────────────

data "azurerm_resource_group" "network_brazilsouth" {
  name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_resource_group" "network_eastus" {
  name = "rg-blog-castilho-network-eastus"
}

# ── Log Analytics Workspaces ───────────────────────────────────────────────────

module "law_brazilsouth" {
  source              = "../../terraform-log-analytics-modules"
  name                = "law-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  retention_in_days   = var.retention_days
  tags                = var.tags
}

module "law_eastus" {
  source              = "../../terraform-log-analytics-modules"
  name                = "law-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.network_eastus.name
  location            = data.azurerm_resource_group.network_eastus.location
  retention_in_days   = var.retention_days
  tags                = var.tags
}

# ── Monitor Action Groups ──────────────────────────────────────────────────────

resource "azurerm_monitor_action_group" "critico" {
  name                = "ag-critico-blog-castilho"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  short_name          = "ag-critico"
  tags                = var.tags

  email_receiver {
    name                    = "time-ops"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  dynamic "webhook_receiver" {
    for_each = var.teams_webhook_uri != "" ? [1] : []
    content {
      name                    = "teams"
      service_uri             = var.teams_webhook_uri
      use_common_alert_schema = true
    }
  }
}

resource "azurerm_monitor_action_group" "aviso" {
  name                = "ag-aviso-blog-castilho"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  short_name          = "ag-aviso"
  tags                = var.tags

  email_receiver {
    name                    = "time-ops"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

# ── Alert Rules ───────────────────────────────────────────────────────────────

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "asr_unhealthy" {
  name                = "asr-replication-unhealthy"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  tags                = var.tags

  evaluation_frequency = "PT5M"
  window_duration      = "PT15M"
  scopes               = [module.law_eastus.workspace_id]
  severity             = 0

  criteria {
    query                   = <<-KQL
      AzureDiagnostics
      | where Category == "AzureSiteRecoveryReplicationStats"
      | extend healthStatus = column_ifexists("ReplicationHealthStatus_s", "Normal")
      | where healthStatus != "Normal"
      | summarize count() by Resource
    KQL
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.critico.id]
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "storage_replication_lag" {
  name                = "storage-replication-lag-5min"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  tags                = var.tags

  evaluation_frequency = "PT5M"
  window_duration      = "PT10M"
  scopes               = [module.law_brazilsouth.workspace_id]
  severity             = 0

  criteria {
    query                   = <<-KQL
      AzureMetrics
      | where MetricName == "GeoReplicationLag"
      | where Average > 300
    KQL
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.critico.id]
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "aks_node_not_ready" {
  name                = "aks-node-not-ready"
  resource_group_name = data.azurerm_resource_group.network_brazilsouth.name
  location            = data.azurerm_resource_group.network_brazilsouth.location
  tags                = var.tags

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [module.law_brazilsouth.workspace_id]
  severity             = 1

  criteria {
    query                   = <<-KQL
      KubeNodeInventory
      | where Status == "NotReady"
      | summarize count() by Computer, TimeGenerated
    KQL
    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.critico.id]
  }
}
