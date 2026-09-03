# Azure DDoS Protection Standard: telemetria de ataque, mitigação automática e
# SLA de disponibilidade para os IPs públicos protegidos.
# Série: artigos-network | Artigo: net-04-ddos-protection
#
# CUSTO: DDoS Protection Standard tem uma taxa fixa mensal (~US$ 2.944, cobrada
# proporcionalmente por hora) — MUITO mais caro que os artigos anteriores da
# série. Não deixar este ambiente no ar além do tempo estritamente necessário
# pra capturar a documentação/screenshots.

resource "azurerm_resource_group" "ddos" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ── DDoS Protection Plan ──────────────────────────────────────────────────────
# O plano em si não está ligado a uma região — pode proteger IPs de VNets em
# regiões diferentes, todos cobertos pela mesma taxa mensal.

resource "azurerm_network_ddos_protection_plan" "this" {
  name                = "ddosplan-blog-castilho"
  resource_group_name = azurerm_resource_group.ddos.name
  location             = azurerm_resource_group.ddos.location
  tags                 = var.tags
}

# ── VNet protegida pelo plano ──────────────────────────────────────────────────

resource "azurerm_virtual_network" "protected" {
  name                = "vnet-ddos-blog-castilho"
  resource_group_name = azurerm_resource_group.ddos.name
  location            = azurerm_resource_group.ddos.location
  address_space       = [var.vnet_address_space]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.this.id
    enable = true
  }

  tags = var.tags
}

resource "azurerm_subnet" "protected" {
  name                 = "snet-ddos"
  resource_group_name  = azurerm_resource_group.ddos.name
  virtual_network_name = azurerm_virtual_network.protected.name
  address_prefixes     = [var.subnet_prefix]
}

# ── Public IP com telemetria de DDoS habilitada individualmente ──────────────
# Desde 2023 o modo de proteção pode ser controlado por IP público (herdar da
# VNet, forçar habilitado, ou forçar desabilitado) — útil quando só alguns IPs
# de uma VNet grande realmente precisam de telemetria dedicada.

resource "azurerm_public_ip" "protected" {
  name                    = "pip-ddos-blog-castilho"
  resource_group_name     = azurerm_resource_group.ddos.name
  location                = azurerm_resource_group.ddos.location
  allocation_method       = "Static"
  sku                     = "Standard"
  ddos_protection_mode    = "Enabled"
  tags                    = var.tags
}
