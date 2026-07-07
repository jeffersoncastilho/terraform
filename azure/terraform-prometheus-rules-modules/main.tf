# Prometheus Rule Group — regras de alerta avaliadas no Azure Monitor Workspace

resource "azurerm_monitor_alert_prometheus_rule_group" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  scopes              = var.scopes
  rule_group_enabled  = var.enabled
  interval            = var.interval
  tags                = var.tags

  dynamic "rule" {
    for_each = var.rules
    content {
      alert       = rule.value.alert
      expression  = rule.value.expression
      for         = rule.value.for
      severity    = rule.value.severity
      labels      = try(rule.value.labels, {})
      annotations = try(rule.value.annotations, {})
    }
  }
}
