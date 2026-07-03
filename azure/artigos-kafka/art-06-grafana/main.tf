data "azurerm_resource_group" "kafka" {
  name = "rg-kafka-blog-castilho-eus"
}

data "azurerm_subscription" "current" {}

module "log_analytics" {
  source              = "../../terraform-log-analytics-modules"
  name                = "law-kafka-blog-castilho-eus"
  resource_group_name = data.azurerm_resource_group.kafka.name
  location            = data.azurerm_resource_group.kafka.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

module "grafana" {
  source                = "../../terraform-grafana-modules"
  name                  = "amg-kafka-castilho-eus"
  resource_group_name   = data.azurerm_resource_group.kafka.name
  location              = data.azurerm_resource_group.kafka.location
  grafana_major_version = 12
  sku                   = "Standard"
  monitoring_scope      = data.azurerm_subscription.current.id
  tags                  = var.tags

  depends_on = [module.log_analytics]
}
