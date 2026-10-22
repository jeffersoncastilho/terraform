# Network Watcher: VNet Flow Log (versão 2, com Traffic Analytics) — visibilidade
# de quem está falando com quem numa VNet, sem precisar habilitar log em cada
# recurso individualmente.
# Série: artigos-network | Artigo: net-06-network-watcher
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules,
# terraform-nsg-modules, terraform-storage-modules,
# terraform-log-analytics-modules e o novo terraform-network-watcher-modules.
#
# Já aplicado/testado/destruído nesta série (2026-09-04) antes da refatoração
# de módulos — evidência real registrada no artigo; após a refatoração,
# reconfirmado só com terraform validate/plan (sem reaplicar).
#
# CAVEAT: o Azure habilita automaticamente um recurso "NetworkWatcher_<região>"
# no resource group "NetworkWatcherRG" assim que a primeira VNet da subscription
# é criada — por isso o módulo de flow log referencia esse nome em vez de criar
# um azurerm_network_watcher próprio (que causaria conflito).

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-netwatcher"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

module "vnet" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-netwatcher-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.vnet_address_space]

  subnets = [
    { key = "netwatcher", name = "snet-netwatcher", address_prefixes = [var.subnet_prefix] },
  ]

  tags = var.tags
}

module "nsg" {
  source = "../../terraform-nsg-modules"

  name                = "nsg-netwatcher-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  subnet_id           = module.vnet.subnets["netwatcher"].id

  security_rules = [
    {
      name                       = "allow-https-inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
  ]

  tags = var.tags
}

# ── Destino dos Flow Logs: Storage Account ────────────────────────────────────

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

module "storage_flowlogs" {
  source = "../../terraform-storage-modules"

  name                = "stflowlogs${random_string.storage_suffix.result}"
  resource_group_name = module.rg.name
  location            = var.location

  tags = var.tags
}

# ── Log Analytics Workspace: alimenta o Traffic Analytics ────────────────────

module "log_analytics" {
  source = "../../terraform-log-analytics-modules"

  name                = "log-netwatcher-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  retention_in_days   = 30

  tags = var.tags
}

# ── VNet Flow Log v2 com Traffic Analytics ────────────────────────────────────
# NSG Flow Logs (o recurso "clássico") pararam de aceitar CRIAÇÃO nova em
# 30/06/2025 — o Azure exige VNet Flow Logs a partir daí (aposentadoria total
# dos NSG Flow Logs em 30/09/2027).

module "flow_log" {
  source = "../../terraform-network-watcher-modules"

  name                                    = "flowlog-netwatcher-blog-castilho"
  location                                = var.location
  target_resource_id                      = module.vnet.vnet_id
  storage_account_id                      = module.storage_flowlogs.storage_account_id
  retention_days                          = var.flow_log_retention_days
  traffic_analytics_workspace_id          = module.log_analytics.customer_id
  traffic_analytics_workspace_region      = var.location
  traffic_analytics_workspace_resource_id = module.log_analytics.workspace_id

  tags = var.tags
}
