data "azurerm_eventhub_namespace" "kafka" {
  name                = "evhns-kafka-blog-castilho-eus"
  resource_group_name = "rg-kafka-blog-castilho-eus"
}

module "schema_registry" {
  source       = "../../terraform-eventhub-schema-modules"
  namespace_id = data.azurerm_eventhub_namespace.kafka.id

  schema_groups = [
    {
      name                 = "sg-avro-blog-castilho-eus"
      schema_type          = "Avro"
      schema_compatibility = "Forward"
    },
  ]
}
