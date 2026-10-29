# Private Link Service: expõe uma aplicação atrás de um Load Balancer interno
# pra ser consumida via Private Endpoint por outra VNet (até de outra
# subscription/tenant) — sem peering, sem rota, sem exposição pública.
# Série: artigos-network | Artigo: net-07-private-link-service
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules,
# terraform-load-balancer-modules, terraform-private-link-service-modules e
# terraform-private-endpoint-modules (os três últimos criados nesta sessão).
#
# Aplicado, testado e destruído em 2026-09-08 (12 recursos, conexão do Private
# Endpoint confirmada como Approved).

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-pls"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

# ── Lado "provedor": VNet + Load Balancer interno + Private Link Service ─────

module "vnet_provider" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-provider-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.provider_vnet_address_space]

  subnets = [
    { key = "provider", name = "snet-provider", address_prefixes = [var.provider_subnet_prefix] },
    # Subnet dedicada exigida pelo Private Link Service para alocar os IPs de
    # NAT usados internamente na tradução do tráfego do consumidor pro backend.
    {
      key                                           = "pls_nat"
      name                                          = "snet-pls-nat"
      address_prefixes                              = [var.pls_nat_subnet_prefix]
      private_link_service_network_policies_enabled = false
    },
  ]

  tags = var.tags
}

module "lb_internal" {
  source = "../../terraform-load-balancer-modules"

  name                = "lb-internal-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  frontend_subnet_id  = module.vnet_provider.subnets["provider"].id
  protocol            = "Tcp"
  port                = 80

  tags = var.tags
}

module "pls" {
  source = "../../terraform-private-link-service-modules"

  name                                       = "pls-blog-castilho"
  resource_group_name                        = module.rg.name
  location                                   = var.location
  nat_subnet_id                              = module.vnet_provider.subnets["pls_nat"].id
  load_balancer_frontend_ip_configuration_id = module.lb_internal.frontend_ip_configuration_id

  tags = var.tags
}

# ── Lado "consumidor": VNet separada consumindo via Private Endpoint ─────────

module "vnet_consumer" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-consumer-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.consumer_vnet_address_space]

  subnets = [
    {
      key                               = "consumer"
      name                              = "snet-consumer"
      address_prefixes                  = [var.consumer_subnet_prefix]
      private_endpoint_network_policies = "Disabled"
    },
  ]

  tags = var.tags
}

module "private_endpoint" {
  source = "../../terraform-private-endpoint-modules"

  name                           = "pe-blog-castilho"
  resource_group_name            = module.rg.name
  location                       = var.location
  subnet_id                      = module.vnet_consumer.subnets["consumer"].id
  private_connection_resource_id = module.pls.id
  # subresource_names não se aplica a Private Link Service

  tags = var.tags
}
