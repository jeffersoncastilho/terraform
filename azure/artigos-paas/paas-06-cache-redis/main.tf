# Azure Cache for Redis: cache gerenciado in-memory, sem operar o Redis você
# mesmo — reduz carga em banco de dados e latência de leitura pra dados
# acessados com frequência.
# Série: artigos-paas | Artigo: paas-06-cache-redis
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.
# SKU Basic C0 é o mais barato (~US$ 16/mês proporcional) — suficiente pra
# demonstrar o recurso sem o custo de tiers com alta disponibilidade (Standard)
# ou clustering (Premium).

resource "azurerm_resource_group" "redis" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_redis_cache" "this" {
  name                = "redis-blog-castilho"
  resource_group_name = azurerm_resource_group.redis.name
  location            = azurerm_resource_group.redis.location

  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = var.tags
}
