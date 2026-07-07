###############################################################################
# Art. 01 — Observabilidade no AKS
# Stack standalone: Azure Monitor Workspace (Prometheus) + Log Analytics +
# Managed Grafana + Application Insights + Prometheus Rule Group.
#
# A associação com o cluster (DCRA, monitor_metrics, oms_agent) é feita no
# ambiente do AKS (art-09) — ver scripts/az-cli-observabilidade-aks.sh.
###############################################################################

data "azurerm_subscription" "current" {}

# Resource Group próprio do lab de observabilidade
module "resource_group" {
  source          = "../../terraform-resource-group-modules"
  resource_type   = "rg"
  project_name    = "observ"
  environment     = "lab"
  location_suffix = "eus"
  location        = var.location
  tags            = var.tags
}

# LOGS — Log Analytics Workspace
module "log_analytics" {
  source              = "../../terraform-log-analytics-modules"
  name                = "law-observ-castilho-eus"
  resource_group_name = module.resource_group.name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# MÉTRICAS — Azure Monitor Workspace (Managed Prometheus) + DCE/DCR
module "monitor_workspace" {
  source              = "../../terraform-monitor-workspace-modules"
  name                = "amw-observ-castilho-eus"
  resource_group_name = module.resource_group.name
  location            = var.location
  create_dcr          = true
  tags                = var.tags
}

# VISUALIZAÇÃO — Azure Managed Grafana
module "grafana" {
  source                = "../../terraform-grafana-modules"
  name                  = "amg-observ-castilho-eus"
  resource_group_name   = module.resource_group.name
  location              = var.location
  grafana_major_version = 12
  sku                   = "Standard"
  monitoring_scope      = data.azurerm_subscription.current.id
  tags                  = var.tags
}

# Grafana precisa ler as métricas Prometheus do Azure Monitor Workspace
module "grafana_amw_reader" {
  source                           = "../../terraform-role-assignment-modules"
  scope                            = module.monitor_workspace.id
  role_definition_name             = "Monitoring Data Reader"
  principal_id                     = module.grafana.principal_id
  skip_service_principal_aad_check = true
}

# TRACES — Application Insights (workspace-based)
module "app_insights" {
  source              = "../../terraform-app-insights-modules"
  name                = "appi-observ-castilho-eus"
  resource_group_name = module.resource_group.name
  location            = var.location
  workspace_id        = module.log_analytics.workspace_id
  application_type    = "web"
  tags                = var.tags
}

# ALERTAS — Prometheus Rule Group (SLO de taxa de erro)
module "prometheus_rules" {
  source              = "../../terraform-prometheus-rules-modules"
  name                = "prg-observ-slo"
  resource_group_name = module.resource_group.name
  location            = var.location
  scopes              = [module.monitor_workspace.id]

  rules = [{
    alert       = "HighErrorRate"
    expression  = "sum(rate(http_requests_total{status=~\"5..\"}[5m])) / sum(rate(http_requests_total[5m])) > 0.05"
    for         = "PT10M"
    severity    = 3
    labels      = { severity = "critical" }
    annotations = { description = "Taxa de erro 5xx acima de 5% no checkout" }
  }]

  tags = var.tags
}
