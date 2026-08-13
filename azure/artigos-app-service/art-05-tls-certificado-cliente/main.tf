# TLS mínimo 1.2 e certificado de cliente (mTLS) no App Service
# Série: artigos-app-service | Artigo: art-05-tls-certificado-cliente

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

# ── Web App dedicado pra demonstrar TLS mínimo + mTLS ────────────────────────

resource "random_string" "app_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "mtls" {
  name                          = "app-mtls-blog-castilho-${random_string.app_suffix.result}"
  resource_group_name           = data.azurerm_resource_group.app_service.name
  location                      = data.azurerm_resource_group.app_service.location
  service_plan_id               = data.azurerm_service_plan.app_service.id
  https_only                    = true
  client_certificate_enabled    = true
  client_certificate_mode       = "Optional"
  client_certificate_exclusion_paths = "/health,/metrics"
  tags                          = var.tags

  site_config {
    minimum_tls_version     = "1.2"
    scm_minimum_tls_version = "1.2"

    application_stack {
      dotnet_version = "8.0"
    }
  }
}
