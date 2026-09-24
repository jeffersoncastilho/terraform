# Azure NAT Gateway: saída de internet controlada e previsível — todo tráfego
# de saída da subnet passa a usar um IP público fixo e conhecido, em vez do
# esquema de portas SNAT dinâmico (e sujeito a esgotamento) do balanceador padrão.
# Série: artigos-network | Artigo: net-03-nat-gateway
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules (com o
# novo suporte a delegation por subnet), terraform-public-ip-modules,
# terraform-nat-gateway-modules (novo) e terraform-aci-modules (estendido
# nesta sessão com subnet_ids/ip_address_type/commands, que não existiam).

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-natgw"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

# ── Rede: VNet + subnet delegada a Container Instances ───────────────────────

module "vnet" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-natgw-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.vnet_address_space]

  subnets = [
    {
      key               = "natgw"
      name              = "snet-natgw"
      address_prefixes  = [var.subnet_prefix]
      delegation = {
        name                        = "aci-delegation"
        service_delegation_name    = "Microsoft.ContainerInstance/containerGroups"
        service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    },
  ]

  tags = var.tags
}

# ── NAT Gateway com IP público fixo ───────────────────────────────────────────

module "pip_natgw" {
  source = "../../terraform-public-ip-modules"

  name                 = "pip-natgw-blog-castilho"
  resource_group_name = module.rg.name
  location             = var.location

  tags = var.tags
}

module "nat_gateway" {
  source = "../../terraform-nat-gateway-modules"

  name                     = "natgw-blog-castilho"
  resource_group_name     = module.rg.name
  location                 = var.location
  idle_timeout_in_minutes  = 4
  public_ip_address_id    = module.pip_natgw.id
  subnet_ids               = [module.vnet.subnets["natgw"].id]

  tags = var.tags
}

# ── Container de teste: faz uma requisição de saída e loga o IP público visto ─
# Roda uma vez (restart_policy = Never) e termina — sem custo de VM parada.

module "aci_test" {
  source = "../../terraform-aci-modules"

  name                 = "aci-natgw-test"
  resource_group_name = module.rg.name
  location             = var.location
  restart_policy       = "Never"
  ip_address_type      = "Private"
  subnet_ids           = [module.vnet.subnets["natgw"].id]

  container_name = "curl-egress-ip"
  # Imagem do Microsoft Container Registry em vez de Docker Hub: pull anônimo
  # do Docker Hub a partir de IPs do Azure esbarra com frequência em rate
  # limit (409 RegistryErrorResponse) — mcr.microsoft.com não tem esse problema.
  image  = "mcr.microsoft.com/azure-cli:latest"
  cpu    = "0.5"
  memory = "0.5"

  # Um Container Instance com VNet integration (subnet_ids) exige pelo menos
  # uma porta declarada no ip_address, mesmo sem precisar expor nada — sem
  # isso a API rejeita com "MissingIpAddressPorts".
  ports = [
    { port = 80, protocol = "TCP" },
  ]

  commands = ["curl", "-s", "https://api.ipify.org", "--max-time", "10"]

  tags = var.tags

  depends_on = [module.nat_gateway]
}
