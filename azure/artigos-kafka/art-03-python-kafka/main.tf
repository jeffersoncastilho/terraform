module "auth_pedidos" {
  source              = "../../terraform-eventhub-auth-modules"
  namespace_name      = "evhns-kafka-blog-castilho-eus"
  eventhub_name       = "evh-pedidos-blog-castilho-eus"
  resource_group_name = "rg-kafka-blog-castilho-eus"

  auth_rules = [
    { name = "rule-producer-pedidos", listen = false, send = true, manage = false },
    { name = "rule-consumer-pedidos", listen = true, send = false, manage = false },
  ]

  consumer_group_names = ["cg-python-app"]
}
