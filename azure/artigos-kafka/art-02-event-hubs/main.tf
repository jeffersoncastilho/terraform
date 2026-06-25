data "azurerm_resource_group" "kafka" {
  name = "rg-kafka-blog-castilho-eus"
}

module "eventhub" {
  source              = "../../terraform-eventhub-modules"
  namespace_name      = "evhns-kafka-blog-castilho-eus"
  resource_group_name = data.azurerm_resource_group.kafka.name
  location            = data.azurerm_resource_group.kafka.location
  sku                 = "Standard"
  capacity            = 2
  tags                = var.tags

  event_hubs = [
    {
      name              = "evh-pedidos-blog-castilho-eus"
      partition_count   = 32
      message_retention = 7
    },
    {
      name              = "evh-pagamentos-blog-castilho-eus"
      partition_count   = 16
      message_retention = 7
    },
    {
      name              = "evh-notificacoes-blog-castilho-eus"
      partition_count   = 8
      message_retention = 3
    },
  ]
}
