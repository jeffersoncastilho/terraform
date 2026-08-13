resource "azurerm_eventhub_authorization_rule" "this" {
  for_each = { for r in var.auth_rules : r.name => r }

  name                = each.key
  namespace_name      = var.namespace_name
  eventhub_name       = var.eventhub_name
  resource_group_name = var.resource_group_name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}

resource "azurerm_eventhub_consumer_group" "this" {
  for_each = toset(var.consumer_group_names)

  name                = each.value
  namespace_name      = var.namespace_name
  eventhub_name       = var.eventhub_name
  resource_group_name = var.resource_group_name
}
