resource "azurerm_automation_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.this.identity[0].principal_id
}

resource "azurerm_automation_runbook" "this" {
  name                    = var.runbook_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = false
  log_progress            = true
  runbook_type            = var.runbook_type
  content                 = var.runbook_content
  tags                    = var.tags
}

resource "azurerm_automation_webhook" "this" {
  count                   = var.create_webhook ? 1 : 0
  name                    = "webhook-${var.runbook_name}"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.this.name
  expiry_time             = var.webhook_expiry_time
  enabled                 = true
  runbook_name            = azurerm_automation_runbook.this.name
}
