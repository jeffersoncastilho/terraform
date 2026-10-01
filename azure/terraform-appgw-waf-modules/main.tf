# Application Gateway v2 (SKU WAF_v2) com WAF Policy (OWASP managed rules) —
# um único listener HTTP, uma única regra de roteamento "Basic" pra um backend
# por FQDN ou IP. Cobre o cenário mais comum de exemplo/tutorial; topologias
# com múltiplos listeners/regras/backends exigem composição no chamador.

resource "azurerm_web_application_firewall_policy" "this" {
  name                = var.waf_policy_name
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled = true
    mode    = var.waf_mode
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = var.owasp_version
    }
  }

  tags = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policy_id  = azurerm_web_application_firewall_policy.this.id

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = var.autoscale_min_capacity
    max_capacity = var.autoscale_max_capacity
  }

  gateway_ip_configuration {
    name      = "gw-ip-config"
    subnet_id = var.gateway_subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = var.public_ip_address_id
  }

  frontend_port {
    name = "port-${var.frontend_port}"
    port = var.frontend_port
  }

  backend_address_pool {
    name         = "backend-pool"
    fqdns        = var.backend_fqdns
    ip_addresses = var.backend_ip_addresses
  }

  backend_http_settings {
    name                                = "http-settings"
    cookie_based_affinity               = "Disabled"
    port                                = var.backend_port
    protocol                            = var.backend_protocol
    request_timeout                     = var.backend_request_timeout
    pick_host_name_from_backend_address = var.backend_pick_host_name
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "port-${var.frontend_port}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule-basic"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
  }

  tags = var.tags
}
