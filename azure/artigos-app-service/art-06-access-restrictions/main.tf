# Access Restrictions por IP e por VNet no App Service
# Série: artigos-app-service | Artigo: art-06-access-restrictions

locals {
  workload    = "app-service"
  name_suffix = "blog-castilho-eus"
}

# ── Recursos existentes do art-01 (fundação da série) ─────────────────────────

data "azurerm_resource_group" "app_service" {
  name = "rg-${local.workload}-${local.name_suffix}"
}

data "azurerm_service_plan" "app_service" {
  name                = "plan-${local.workload}-${local.name_suffix}"
  resource_group_name = data.azurerm_resource_group.app_service.name
}

# ── VNet com subnet habilitada pra restrição por serviço (service endpoint) ──

module "vnet" {
  source              = "../../terraform-virtual-network-modules"
  name                = "vnet-${local.workload}-${local.name_suffix}"
  resource_group_name = data.azurerm_resource_group.app_service.name
  location            = data.azurerm_resource_group.app_service.location
  address_space       = ["10.10.0.0/24"]

  subnets = [
    { key = "restricted", name = "snet-restricted-${local.name_suffix}", address_prefixes = ["10.10.0.0/26"] },
  ]

  tags = var.tags
}

# ── Web App dedicado pra demonstrar Access Restrictions ──────────────────────

resource "random_string" "app_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "restricted" {
  name                = "app-restricted-blog-castilho-${random_string.app_suffix.result}"
  resource_group_name = data.azurerm_resource_group.app_service.name
  location            = data.azurerm_resource_group.app_service.location
  service_plan_id     = data.azurerm_service_plan.app_service.id
  https_only          = true
  tags                = var.tags

  site_config {
    ip_restriction_default_action = "Deny"

    application_stack {
      dotnet_version = "8.0"
    }

    ip_restriction {
      name        = "allow-escritorio"
      priority    = 100
      action      = "Allow"
      ip_address  = "203.0.113.0/24"
      description = "Faixa de IP de exemplo do escritório"
    }

    ip_restriction {
      name                      = "allow-subnet-restricted"
      priority                  = 200
      action                    = "Allow"
      virtual_network_subnet_id = module.vnet.subnets["restricted"].id
      description               = "Subnet interna via VNet Integration"
    }
  }
}
