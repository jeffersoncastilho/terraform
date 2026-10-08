# Azure DDoS Protection Standard: telemetria de ataque, mitigação automática e
# SLA de disponibilidade para os IPs públicos protegidos.
# Série: artigos-network | Artigo: net-04-ddos-protection
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules (com o
# novo suporte a ddos_protection_plan_id), terraform-public-ip-modules (com o
# novo suporte a ddos_protection_mode) e o novo terraform-ddos-protection-modules.
#
# CUSTO: DDoS Protection Standard tem uma taxa fixa mensal (~US$ 2.944, cobrada
# proporcionalmente por hora) — MUITO mais caro que os artigos anteriores da
# série. Não deixar este ambiente no ar além do tempo estritamente necessário
# pra capturar a documentação/screenshots.

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-ddos"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

# ── DDoS Protection Plan ──────────────────────────────────────────────────────
# O plano em si não está ligado a uma região — pode proteger IPs de VNets em
# regiões diferentes, todos cobertos pela mesma taxa mensal.

module "ddos_plan" {
  source = "../../terraform-ddos-protection-modules"

  name                = "ddosplan-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location

  tags = var.tags
}

# ── VNet protegida pelo plano ──────────────────────────────────────────────────

module "vnet" {
  source = "../../terraform-virtual-network-modules"

  name                    = "vnet-ddos-blog-castilho"
  resource_group_name     = module.rg.name
  location                = var.location
  address_space           = [var.vnet_address_space]
  ddos_protection_plan_id = module.ddos_plan.id

  subnets = [
    { key = "ddos", name = "snet-ddos", address_prefixes = [var.subnet_prefix] },
  ]

  tags = var.tags
}

# ── Public IP com telemetria de DDoS habilitada individualmente ──────────────
# Desde 2023 o modo de proteção pode ser controlado por IP público (herdar da
# VNet, forçar habilitado, ou forçar desabilitado) — útil quando só alguns IPs
# de uma VNet grande realmente precisam de telemetria dedicada.

module "pip_protected" {
  source = "../../terraform-public-ip-modules"

  name                 = "pip-ddos-blog-castilho"
  resource_group_name  = module.rg.name
  location             = var.location
  ddos_protection_mode = "Enabled"

  tags = var.tags
}
