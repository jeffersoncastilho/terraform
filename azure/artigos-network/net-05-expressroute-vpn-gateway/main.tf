# ExpressRoute vs VPN Gateway: os dois jeitos de conectar um datacenter
# on-premises ao Azure. Este módulo declara os dois lado a lado para
# comparação — na prática você normalmente escolhe um dos dois (ou os dois,
# como fallback um do outro, em cenários críticos).
# Série: artigos-network | Artigo: net-05-expressroute-vpn-gateway
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules,
# terraform-public-ip-modules, terraform-vpn-gateway-modules (mesmo módulo
# usado pelo net-08, aqui sem vpn_client_configuration = cenário S2S) e o
# novo terraform-expressroute-modules. Local Network Gateway e a conexão
# IPsec continuam como recursos diretos aqui — são específicos de S2S, não
# fazem parte do módulo genérico de VPN Gateway.
#
# NÃO APLICADO nesta sessão: VPN Gateway leva 30-45min pra provisionar e
# ExpressRoute Circuit gera custo mensal mesmo sem circuito físico conectado
# por um provedor — ambos exigem decisão de custo/tempo em tempo real, que
# não faz sentido tomar sem o usuário acompanhando. Código validado
# (terraform validate + plan), pronto pra aplicar quando for a hora certa.

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-hybrid"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

module "vnet" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-hybrid-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.vnet_address_space]

  # O nome "GatewaySubnet" é obrigatório — o Azure só reconhece um gateway
  # (VPN ou ExpressRoute) numa subnet com esse nome exato.
  subnets = [
    { key = "gateway", name = "GatewaySubnet", address_prefixes = [var.gateway_subnet_prefix] },
  ]

  tags = var.tags
}

# ── VPN Gateway (site-to-site via IPsec) ──────────────────────────────────────

module "pip_vpn_gateway" {
  source = "../../terraform-public-ip-modules"

  name                = "pip-vpngw-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  # VpnGw1AZ exige Public IP zone-redundant (VmssVpnGatewayPublicIpsMustHaveZonesConfigured)
  zones = ["1", "2", "3"]

  tags = var.tags
}

module "vpn_gateway" {
  source = "../../terraform-vpn-gateway-modules"

  name                 = "vpngw-blog-castilho"
  resource_group_name  = module.rg.name
  location             = var.location
  gateway_subnet_id    = module.vnet.subnets["gateway"].id
  public_ip_address_id = module.pip_vpn_gateway.id
  sku                  = "VpnGw1AZ"
  # vpn_client_configuration não informado = gateway sem P2S (só S2S aqui)

  tags = var.tags
}

# Representa o roteador VPN do "outro lado" (on-premises) — em produção o IP
# e o address_space vêm do equipamento real do datacenter/fornecedor.
resource "azurerm_local_network_gateway" "on_premises" {
  name                = "lng-on-premises-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  gateway_address     = var.on_premises_gateway_ip
  address_space       = [var.on_premises_address_space]
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "site_to_site" {
  name                       = "conn-site-to-site-blog-castilho"
  resource_group_name        = module.rg.name
  location                   = var.location
  type                       = "IPsec"
  virtual_network_gateway_id = module.vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.on_premises.id
  shared_key                 = var.shared_key
  tags                       = var.tags
}

# ── ExpressRoute Circuit ───────────────────────────────────────────────────────
# O circuito em si não conecta a nenhuma VNet até uma "ExpressRoute Gateway"
# ser criada e uma conexão ser estabelecida — igual ao VPN Gateway, mas com
# gateway do tipo ExpressRoute em vez de Vpn. Aqui declaramos só o circuito,
# que é o recurso cobrado mensalmente e o que exige negociação com o provedor.

module "expressroute" {
  source = "../../terraform-expressroute-modules"

  name                  = "expressroute-blog-castilho"
  resource_group_name   = module.rg.name
  location              = var.location
  service_provider_name = var.expressroute_service_provider
  peering_location      = var.expressroute_peering_location
  bandwidth_in_mbps     = var.expressroute_bandwidth_mbps

  tags = var.tags
}
