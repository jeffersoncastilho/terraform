# Application Gateway v2 com WAF (OWASP managed rules) na frente de um backend
# de teste (Storage Static Website, sem VM/App Service pra manter custo mínimo).
# Série: artigos-network | Artigo: net-02-appgw-waf

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "appgw" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ── Backend de teste: Storage Static Website (sem VM, custo mínimo) ──────────

resource "azurerm_storage_account" "backend" {
  name                     = "stappgwbackend${random_string.storage_suffix.result}"
  resource_group_name     = azurerm_resource_group.appgw.name
  location                = azurerm_resource_group.appgw.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "backend" {
  storage_account_id = azurerm_storage_account.backend.id
  index_document      = "index.html"
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name  = azurerm_storage_account.backend.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = "<html><body><h1>Backend protegido pelo Application Gateway + WAF</h1></body></html>"

  depends_on = [azurerm_storage_account_static_website.backend]
}

# ── Rede: VNet + subnet dedicada ao Application Gateway ──────────────────────

resource "azurerm_virtual_network" "appgw" {
  name                = "vnet-appgw-blog-castilho"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "appgw" {
  name                 = "snet-appgw"
  resource_group_name  = azurerm_resource_group.appgw.name
  virtual_network_name = azurerm_virtual_network.appgw.name
  address_prefixes     = [var.appgw_subnet_prefix]
}

resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-blog-castilho"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# ── WAF Policy (OWASP managed rules, modo Prevention) ─────────────────────────

resource "azurerm_web_application_firewall_policy" "this" {
  name                = "wafpolicy-blog-castilho"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  tags = var.tags
}

# ── Application Gateway v2 (SKU WAF_v2) ───────────────────────────────────────

resource "azurerm_application_gateway" "this" {
  name                = "agw-blog-castilho"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location
  firewall_policy_id  = azurerm_web_application_firewall_policy.this.id

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "gw-ip-config"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = "port-80"
    port = 80
  }

  backend_address_pool {
    name  = "backend-storage"
    fqdns = [replace(replace(azurerm_storage_account.backend.primary_web_endpoint, "https://", ""), "/", "")]
  }

  # Storage Static Website só responde em HTTPS (https_traffic_only_enabled = true
  # por padrão no provider) — o Application Gateway fala HTTP com o cliente (porta 80,
  # sem certificado próprio pra manter o exemplo simples) mas HTTPS com esse backend.
  backend_http_settings {
    name                                = "http-settings"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = "listener-http"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "port-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule-basic"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "listener-http"
    backend_address_pool_name  = "backend-storage"
    backend_http_settings_name = "http-settings"
  }

  tags = var.tags
}
