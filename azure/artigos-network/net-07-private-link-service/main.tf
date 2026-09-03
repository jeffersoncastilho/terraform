# Private Link Service: expõe uma aplicação atrás de um Load Balancer interno
# pra ser consumida via Private Endpoint por outra VNet (até de outra
# subscription/tenant) — sem peering, sem rota, sem exposição pública.
# Série: artigos-network | Artigo: net-07-private-link-service
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.

resource "azurerm_resource_group" "pls" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ── Lado "provedor": VNet + Load Balancer interno + Private Link Service ─────

resource "azurerm_virtual_network" "provider" {
  name                = "vnet-provider-blog-castilho"
  resource_group_name = azurerm_resource_group.pls.name
  location            = azurerm_resource_group.pls.location
  address_space       = [var.provider_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "provider" {
  name                 = "snet-provider"
  resource_group_name  = azurerm_resource_group.pls.name
  virtual_network_name = azurerm_virtual_network.provider.name
  address_prefixes     = [var.provider_subnet_prefix]
}

# Subnet dedicada exigida pelo Private Link Service para alocar os IPs de NAT
# usados internamente na tradução do tráfego do consumidor pro backend.
resource "azurerm_subnet" "pls_nat" {
  name                 = "snet-pls-nat"
  resource_group_name  = azurerm_resource_group.pls.name
  virtual_network_name = azurerm_virtual_network.provider.name
  address_prefixes     = [var.pls_nat_subnet_prefix]

  private_link_service_network_policies_enabled = false
}

resource "azurerm_lb" "internal" {
  name                = "lb-internal-blog-castilho"
  resource_group_name = azurerm_resource_group.pls.name
  location            = azurerm_resource_group.pls.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "frontend-internal"
    subnet_id                     = azurerm_subnet.provider.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "internal" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.internal.id
}

resource "azurerm_lb_probe" "http" {
  name            = "probe-http"
  loadbalancer_id = azurerm_lb.internal.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http" {
  name                           = "rule-http"
  loadbalancer_id                = azurerm_lb.internal.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-internal"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.internal.id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_private_link_service" "this" {
  name                = "pls-blog-castilho"
  resource_group_name = azurerm_resource_group.pls.name
  location            = azurerm_resource_group.pls.location

  nat_ip_configuration {
    name      = "nat-primary"
    subnet_id = azurerm_subnet.pls_nat.id
    primary   = true
  }

  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.internal.frontend_ip_configuration[0].id,
  ]

  tags = var.tags
}

# ── Lado "consumidor": VNet separada consumindo via Private Endpoint ─────────

resource "azurerm_virtual_network" "consumer" {
  name                = "vnet-consumer-blog-castilho"
  resource_group_name = azurerm_resource_group.pls.name
  location            = azurerm_resource_group.pls.location
  address_space       = [var.consumer_vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "consumer" {
  name                 = "snet-consumer"
  resource_group_name  = azurerm_resource_group.pls.name
  virtual_network_name = azurerm_virtual_network.consumer.name
  address_prefixes     = [var.consumer_subnet_prefix]

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_private_endpoint" "this" {
  name                = "pe-blog-castilho"
  resource_group_name = azurerm_resource_group.pls.name
  location            = azurerm_resource_group.pls.location
  subnet_id           = azurerm_subnet.consumer.id

  private_service_connection {
    name                           = "psc-pls-blog-castilho"
    private_connection_resource_id = azurerm_private_link_service.this.id
    is_manual_connection            = false
  }

  tags = var.tags
}
