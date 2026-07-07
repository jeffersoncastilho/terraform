# Application Insights (workspace-based) — recebe traces/telemetria via OpenTelemetry

resource "azurerm_application_insights" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = var.application_type
  workspace_id        = var.workspace_id
  sampling_percentage = var.sampling_percentage
  tags                = var.tags
}
