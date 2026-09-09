# VPN Gateway Point-to-Site (P2S) com autenticação por certificado —
# a mesma configuração afetada pelo aviso da Microsoft de migração de
# certificado de gateway (prazo: 31/01/2027, ver artigo).
# Série: artigos-network | Artigo: net-08-vpn-gateway-p2s
#
# Refatorado para consumir os módulos reutilizáveis da biblioteca
# (public/terraform/azure/terraform-*-modules) em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules,
# terraform-public-ip-modules e terraform-vpn-gateway-modules (este
# último criado nesta sessão, pois não existia módulo de VPN Gateway).
#
# NÃO APLICADO nesta sessão: VPN Gateway leva 30-45min pra provisionar
# (mesmo caveat do net-05) — código validado (terraform validate + plan),
# pronto pra aplicar quando fizer sentido demonstrar o fluxo de verdade.

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-vpn-p2s"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

module "vnet" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-p2s-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.vnet_address_space]

  # O nome "GatewaySubnet" é obrigatório — o Azure só reconhece um
  # gateway (VPN ou ExpressRoute) numa subnet com esse nome exato.
  subnets = [
    { key = "gateway", name = "GatewaySubnet", address_prefixes = [var.gateway_subnet_prefix] },
  ]

  tags = var.tags
}

module "pip_vpn_gateway" {
  source = "../../terraform-public-ip-modules"

  name                 = "pip-vpngw-p2s-blog-castilho"
  resource_group_name = module.rg.name
  location             = var.location

  tags = var.tags
}

# A configuração P2S vive dentro do próprio Virtual Network Gateway —
# não é um recurso separado. É o bloco `vpn_client_configuration` do
# módulo que define o pool de IPs dos clientes, os protocolos aceitos e,
# no caso de autenticação por certificado, o certificado raiz confiável
# (o mesmo tipo de material que o aviso de migração da Microsoft afeta).
module "vpn_gateway_p2s" {
  source = "../../terraform-vpn-gateway-modules"

  name                 = "vpngw-p2s-blog-castilho"
  resource_group_name  = module.rg.name
  location             = var.location
  gateway_subnet_id    = module.vnet.subnets["gateway"].id
  public_ip_address_id = module.pip_vpn_gateway.id
  sku                  = "VpnGw1"

  vpn_client_configuration = {
    address_space        = [var.p2s_address_pool]
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["Certificate"]

    root_certificates = [{
      name             = var.root_cert_name
      public_cert_data = file(var.root_cert_public_data_path)
    }]
  }

  tags = var.tags
}
