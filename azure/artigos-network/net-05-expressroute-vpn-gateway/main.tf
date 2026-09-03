# ExpressRoute vs VPN Gateway: os dois jeitos de conectar um datacenter
# on-premises ao Azure. Este módulo declara os dois lado a lado para
# comparação — na prática você normalmente escolhe um dos dois (ou os dois,
# como fallback um do outro, em cenários críticos).
# Série: artigos-network | Artigo: net-05-expressroute-vpn-gateway
#
# NÃO APLICADO nesta sessão: VPN Gateway leva 30-45min pra provisionar e
# ExpressRoute Circuit gera custo mensal mesmo sem circuito físico conectado
# por um provedor — ambos exigem decisão de custo/tempo em tempo real, que
# não faz sentido tomar sem o usuário acompanhando. Código validado
# (terraform validate + plan), pronto pra aplicar quando for a hora certa.

resource "azurerm_resource_group" "hybrid" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hybrid" {
  name                = "vnet-hybrid-blog-castilho"
  resource_group_name = azurerm_resource_group.hybrid.name
  location            = azurerm_resource_group.hybrid.location
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

# O nome "GatewaySubnet" é obrigatório — o Azure só reconhece um gateway
# (VPN ou ExpressRoute) numa subnet com esse nome exato.
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hybrid.name
  virtual_network_name = azurerm_virtual_network.hybrid.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

# ── VPN Gateway (site-to-site via IPsec) ──────────────────────────────────────

resource "azurerm_public_ip" "vpn_gateway" {
  name                = "pip-vpngw-blog-castilho"
  resource_group_name = azurerm_resource_group.hybrid.name
  location            = azurerm_resource_group.hybrid.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "vpngw-blog-castilho"
  resource_group_name = azurerm_resource_group.hybrid.name
  location            = azurerm_resource_group.hybrid.location
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id         = azurerm_public_ip.vpn_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                    = azurerm_subnet.gateway.id
  }

  tags = var.tags
}

# Representa o roteador VPN do "outro lado" (on-premises) — em produção o IP
# e o address_space vêm do equipamento real do datacenter/fornecedor.
resource "azurerm_local_network_gateway" "on_premises" {
  name                = "lng-on-premises-blog-castilho"
  resource_group_name = azurerm_resource_group.hybrid.name
  location            = azurerm_resource_group.hybrid.location
  gateway_address     = var.on_premises_gateway_ip
  address_space       = [var.on_premises_address_space]
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "site_to_site" {
  name                       = "conn-site-to-site-blog-castilho"
  resource_group_name       = azurerm_resource_group.hybrid.name
  location                   = azurerm_resource_group.hybrid.location
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn.id
  local_network_gateway_id  = azurerm_local_network_gateway.on_premises.id
  shared_key                 = var.shared_key
  tags                       = var.tags
}

# ── ExpressRoute Circuit ───────────────────────────────────────────────────────
# O circuito em si não conecta a nenhuma VNet até uma "ExpressRoute Gateway"
# ser criada e uma conexão ser estabelecida — igual ao VPN Gateway, mas com
# gateway do tipo ExpressRoute em vez de Vpn. Aqui declaramos só o circuito,
# que é o recurso cobrado mensalmente e o que exige negociação com o provedor.

resource "azurerm_express_route_circuit" "this" {
  name                  = "expressroute-blog-castilho"
  resource_group_name   = azurerm_resource_group.hybrid.name
  location              = azurerm_resource_group.hybrid.location
  service_provider_name = var.expressroute_service_provider
  peering_location      = var.expressroute_peering_location
  bandwidth_in_mbps     = var.expressroute_bandwidth_mbps

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = var.tags
}
