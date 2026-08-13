resource "azurerm_eventhub_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity
  tags                = var.tags
}

resource "azurerm_eventhub" "this" {
  for_each = { for eh in var.event_hubs : eh.name => eh }

  name              = each.value.name
  namespace_id      = azurerm_eventhub_namespace.this.id
  partition_count   = each.value.partition_count
  message_retention = each.value.message_retention
}
