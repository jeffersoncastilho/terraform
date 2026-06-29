data "azurerm_resource_group" "kafka" {
  name = "rg-kafka-blog-castilho-eus"
}

locals {
  acr_name      = "acrkafkablogcastilhoeus"
  connect_image = "confluentinc/cp-kafka-connect:7.6.0"
  acr_image     = "${local.acr_name}.azurecr.io/${local.connect_image}"
}

module "acr" {
  source              = "../../terraform-acr-modules"
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.kafka.name
  location            = data.azurerm_resource_group.kafka.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}

resource "null_resource" "import_kafka_connect_image" {
  triggers = {
    acr_id = module.acr.registry_id
    image  = local.connect_image
  }

  provisioner "local-exec" {
    command = "az acr import --name ${local.acr_name} --source docker.io/${local.connect_image} --image ${local.connect_image} --username ${var.dockerhub_username} --password ${var.dockerhub_password} --force"
  }

  depends_on = [module.acr]
}

module "kafka_connect" {
  source              = "../../terraform-aci-modules"
  name                = "aci-kafka-connect-blog-castilho-eus"
  resource_group_name = data.azurerm_resource_group.kafka.name
  location            = data.azurerm_resource_group.kafka.location
  container_name      = "kafka-connect"
  image               = local.acr_image
  cpu                 = "1.0"
  memory              = "2.0"
  restart_policy      = "Always"

  image_registry_credentials = [
    {
      server   = module.acr.login_server
      username = module.acr.admin_username
      password = module.acr.admin_password
    }
  ]

  ports = [
    { port = 8083, protocol = "TCP" },
  ]

  environment_variables = {
    CONNECT_BOOTSTRAP_SERVERS                 = "evhns-kafka-blog-castilho-eus.servicebus.windows.net:9093"
    CONNECT_GROUP_ID                          = "kafka-connect-group"
    CONNECT_CONFIG_STORAGE_TOPIC              = "__connect-configs"
    CONNECT_OFFSET_STORAGE_TOPIC              = "__connect-offsets"
    CONNECT_STATUS_STORAGE_TOPIC              = "__connect-status"
    CONNECT_REST_PORT                         = "8083"
    CONNECT_SECURITY_PROTOCOL                 = "SASL_SSL"
    CONNECT_SASL_MECHANISM                    = "PLAIN"
    CONNECT_KEY_CONVERTER                     = "org.apache.kafka.connect.storage.StringConverter"
    CONNECT_VALUE_CONVERTER                   = "org.apache.kafka.connect.json.JsonConverter"
    CONNECT_VALUE_CONVERTER_SCHEMAS_ENABLE    = "false"
    CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR = "1"
    CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR = "1"
    CONNECT_STATUS_STORAGE_REPLICATION_FACTOR = "1"
  }

  secure_environment_variables = {
    CONNECT_SASL_JAAS_CONFIG = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"${var.kafka_connect_sasl_password}\";"
  }

  tags = var.tags

  depends_on = [null_resource.import_kafka_connect_image]
}
