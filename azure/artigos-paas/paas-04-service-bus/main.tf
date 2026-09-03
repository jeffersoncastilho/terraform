# Azure Service Bus: fila (point-to-point) e tópico com assinaturas
# (publish/subscribe) — mensageria gerenciada com garantia de entrega,
# dead-lettering e sessões, sem operar um broker próprio.
# Série: artigos-paas | Artigo: paas-04-service-bus
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.
# SKU Standard cobra por operação (sem taxa fixa alta) — um dos mais baratos
# de testar da série, junto com Container Apps.

resource "azurerm_resource_group" "servicebus" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_servicebus_namespace" "this" {
  name                = "sbns-blog-castilho"
  resource_group_name = azurerm_resource_group.servicebus.name
  location            = azurerm_resource_group.servicebus.location
  sku                 = "Standard"
  tags                = var.tags
}

# ── Fila: consumo point-to-point, um consumidor processa cada mensagem ──────

resource "azurerm_servicebus_queue" "orders" {
  name         = "queue-orders"
  namespace_id = azurerm_servicebus_namespace.this.id

  max_delivery_count                  = 5
  dead_lettering_on_message_expiration = true
  default_message_ttl                  = "P1D"
}

# ── Tópico + assinaturas: publish/subscribe, cada assinante recebe uma cópia ─

resource "azurerm_servicebus_topic" "events" {
  name         = "topic-events"
  namespace_id = azurerm_servicebus_namespace.this.id
}

resource "azurerm_servicebus_subscription" "billing" {
  name               = "sub-billing"
  topic_id           = azurerm_servicebus_topic.events.id
  max_delivery_count = 5
}

resource "azurerm_servicebus_subscription" "notifications" {
  name               = "sub-notifications"
  topic_id           = azurerm_servicebus_topic.events.id
  max_delivery_count = 5
}

# Filtro SQL: a assinatura "billing" só recebe eventos do tipo "order.paid",
# mesmo que o tópico receba tipos variados de eventos.
resource "azurerm_servicebus_subscription_rule" "billing_filter" {
  name            = "only-order-paid"
  subscription_id = azurerm_servicebus_subscription.billing.id
  filter_type     = "SqlFilter"
  sql_filter      = "EventType = 'order.paid'"
}
