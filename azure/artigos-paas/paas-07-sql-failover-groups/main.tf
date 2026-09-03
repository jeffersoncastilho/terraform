# Azure SQL Database com Failover Group: failover automático (ou manual) entre
# duas regiões, com um endpoint de conexão único que não muda — a aplicação
# não precisa saber pra qual servidor está apontando de fato.
# Série: artigos-paas | Artigo: paas-07-sql-failover-groups
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.
# Custo relativamente baixo: os SQL Servers em si são gratuitos, só a
# database (SKU Basic/S0) cobra por hora — bem mais barato que Cosmos DB
# multi-região ou VPN Gateway.

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "sql_ha" {
  name     = var.resource_group_name
  location = var.primary_location
  tags     = var.tags
}

resource "azurerm_mssql_server" "primary" {
  name                         = "sql-primary-blog-castilho-${random_string.suffix.result}"
  resource_group_name         = azurerm_resource_group.sql_ha.name
  location                     = azurerm_resource_group.sql_ha.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version           = "1.2"
  tags                          = var.tags
}

resource "azurerm_mssql_server" "secondary" {
  name                         = "sql-secondary-blog-castilho-${random_string.suffix.result}"
  resource_group_name         = azurerm_resource_group.sql_ha.name
  location                     = var.secondary_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version           = "1.2"
  tags                          = var.tags
}

resource "azurerm_mssql_database" "this" {
  name        = "db-blog-castilho"
  server_id   = azurerm_mssql_server.primary.id
  sku_name    = "Basic"
  max_size_gb = 2
  tags        = var.tags
}

resource "azurerm_mssql_failover_group" "this" {
  name      = "fog-blog-castilho"
  server_id = azurerm_mssql_server.primary.id
  databases = [azurerm_mssql_database.this.id]

  partner_server {
    id = azurerm_mssql_server.secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }

  tags = var.tags
}
