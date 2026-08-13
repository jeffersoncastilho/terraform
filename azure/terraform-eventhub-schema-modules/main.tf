resource "azurerm_eventhub_namespace_schema_group" "this" {
  for_each = { for sg in var.schema_groups : sg.name => sg }

  name                 = each.key
  namespace_id         = var.namespace_id
  schema_compatibility = each.value.schema_compatibility
  schema_type          = each.value.schema_type
}
