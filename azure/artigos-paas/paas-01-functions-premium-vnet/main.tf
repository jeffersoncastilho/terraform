# Azure Functions Premium (Elastic Premium) com integração de VNet — a Function
# App consegue chamar recursos privados (banco, storage com Private Endpoint,
# etc.) da VNet, algo que o plano Consumption não permite.
# Série: artigos-paas | Artigo: paas-01-functions-premium-vnet
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.
# Plano Elastic Premium EP1 custa proporcionalmente por hora (~US$ 0,20/h) —
# não é gratuito como os artigos net-01/03/06/07, mas bem mais barato que
# VPN Gateway ou DDoS Protection Standard.

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "functions" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ── Rede: VNet + subnet delegada ao App Service (Functions Premium usa o
# mesmo mecanismo de integração de VNet regional do App Service) ─────────────

resource "azurerm_virtual_network" "functions" {
  name                = "vnet-functions-blog-castilho"
  resource_group_name = azurerm_resource_group.functions.name
  location            = azurerm_resource_group.functions.location
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "functions" {
  name                 = "snet-functions"
  resource_group_name  = azurerm_resource_group.functions.name
  virtual_network_name = azurerm_virtual_network.functions.name
  address_prefixes     = [var.functions_subnet_prefix]

  delegation {
    name = "functions-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# ── Storage Account: obrigatório para qualquer Function App ──────────────────

resource "azurerm_storage_account" "functions" {
  name                     = "stfuncsblog${random_string.storage_suffix.result}"
  resource_group_name     = azurerm_resource_group.functions.name
  location                = azurerm_resource_group.functions.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

# ── App Service Plan Elastic Premium (EP1) ────────────────────────────────────

resource "azurerm_service_plan" "premium" {
  name                = "plan-functions-blog-castilho"
  resource_group_name = azurerm_resource_group.functions.name
  location            = azurerm_resource_group.functions.location
  os_type             = "Linux"
  sku_name            = "EP1"
  tags                = var.tags
}

# ── Function App com integração de VNet regional ──────────────────────────────

resource "azurerm_linux_function_app" "this" {
  name                = "func-blog-castilho-${random_string.storage_suffix.result}"
  resource_group_name = azurerm_resource_group.functions.name
  location            = azurerm_resource_group.functions.location

  storage_account_name      = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key
  service_plan_id            = azurerm_service_plan.premium.id

  virtual_network_subnet_id = azurerm_subnet.functions.id

  site_config {
    vnet_route_all_enabled = true

    application_stack {
      node_version = "20"
    }
  }

  app_settings = {
    "WEBSITE_VNET_ROUTE_ALL" = "1"
  }

  tags = var.tags
}
