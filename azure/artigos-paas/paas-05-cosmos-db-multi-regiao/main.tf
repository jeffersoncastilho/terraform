# Azure Cosmos DB com replicação multi-região e failover automático —
# escritas continuam funcionando mesmo se a região primária cair, sem
# intervenção manual.
# Série: artigos-paas | Artigo: paas-05-cosmos-db-multi-regiao
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.
# CUSTO: throughput provisionado (mesmo no mínimo de 400 RU/s) cobra por hora
# enquanto existir, multiplicado por região — com 2 regiões isso já é mais
# caro que a maioria dos artigos anteriores (exceto DDoS/VPN Gateway). O modo
# Serverless seria mais barato, mas NÃO suporta múltiplas regiões — incompatível
# com o próprio tema do artigo, por isso não foi usado aqui.

resource "azurerm_resource_group" "cosmosdb" {
  name     = var.resource_group_name
  location = var.primary_location
  tags     = var.tags
}

resource "azurerm_cosmosdb_account" "this" {
  name                = "cosmos-blog-castilho"
  resource_group_name = azurerm_resource_group.cosmosdb.name
  location            = azurerm_resource_group.cosmosdb.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  # multi_write habilita escrita em qualquer região do failover_group, não só
  # na primária — é a diferença central entre "multi-região com failover
  # manual" e "multi-região com escrita em qualquer lugar".
  automatic_failover_enabled = true
  multiple_write_locations_enabled = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.cosmosdb.location
    failover_priority = 0
  }

  geo_location {
    location          = var.secondary_location
    failover_priority = 1
  }

  tags = var.tags
}

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = "db-blog-castilho"
  resource_group_name = azurerm_resource_group.cosmosdb.name
  account_name        = azurerm_cosmosdb_account.this.name
}

resource "azurerm_cosmosdb_sql_container" "this" {
  name                = "container-eventos"
  resource_group_name = azurerm_resource_group.cosmosdb.name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this.name
  partition_key_paths  = ["/eventType"]
  throughput           = 400
}
