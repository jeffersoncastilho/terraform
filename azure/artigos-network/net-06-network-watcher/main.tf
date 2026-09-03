# Network Watcher: NSG Flow Logs (versão 2, com Traffic Analytics) — visibilidade
# de quem está falando com quem numa VNet, sem precisar habilitar log em cada
# recurso individualmente.
# Série: artigos-network | Artigo: net-06-network-watcher
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário estava ausente e todo apply
# desta série até aqui exigiu confirmação ao vivo; ficou pendente pra quando
# ele retomar. Terraform validado (terraform validate + plan limpos).
#
# CAVEAT para quando for aplicar: o Azure habilita automaticamente um recurso
# "NetworkWatcher_<região>" no resource group "NetworkWatcherRG" assim que a
# primeira VNet da subscription é criada. Tentar criar um `azurerm_network_watcher`
# next a essa região pode falhar com conflito — nesse caso, usar
# `terraform import` para trazer o Network Watcher auto-criado pro state, ou
# referenciá-lo via data source em vez de criar um novo.

resource "azurerm_resource_group" "netwatcher" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "netwatcher" {
  name                = "vnet-netwatcher-blog-castilho"
  resource_group_name = azurerm_resource_group.netwatcher.name
  location            = azurerm_resource_group.netwatcher.location
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_network_security_group" "netwatcher" {
  name                = "nsg-netwatcher-blog-castilho"
  resource_group_name = azurerm_resource_group.netwatcher.name
  location            = azurerm_resource_group.netwatcher.location

  security_rule {
    name                       = "allow-https-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet" "netwatcher" {
  name                 = "snet-netwatcher"
  resource_group_name  = azurerm_resource_group.netwatcher.name
  virtual_network_name = azurerm_virtual_network.netwatcher.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_subnet_network_security_group_association" "netwatcher" {
  subnet_id                 = azurerm_subnet.netwatcher.id
  network_security_group_id = azurerm_network_security_group.netwatcher.id
}

# ── Destino dos Flow Logs: Storage Account ────────────────────────────────────

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "flowlogs" {
  name                     = "stflowlogs${random_string.storage_suffix.result}"
  resource_group_name     = azurerm_resource_group.netwatcher.name
  location                = azurerm_resource_group.netwatcher.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

# ── Log Analytics Workspace: alimenta o Traffic Analytics ────────────────────

resource "azurerm_log_analytics_workspace" "netwatcher" {
  name                = "log-netwatcher-blog-castilho"
  resource_group_name = azurerm_resource_group.netwatcher.name
  location            = azurerm_resource_group.netwatcher.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# ── NSG Flow Log v2 com Traffic Analytics ─────────────────────────────────────

resource "azurerm_network_watcher_flow_log" "this" {
  name                     = "flowlog-netwatcher-blog-castilho"
  network_watcher_name     = "NetworkWatcher_${var.location}"
  resource_group_name      = "NetworkWatcherRG"
  network_security_group_id = azurerm_network_security_group.netwatcher.id
  storage_account_id       = azurerm_storage_account.flowlogs.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.netwatcher.workspace_id
    workspace_region      = azurerm_log_analytics_workspace.netwatcher.location
    workspace_resource_id = azurerm_log_analytics_workspace.netwatcher.id
    interval_in_minutes   = 10
  }

  tags = var.tags
}
