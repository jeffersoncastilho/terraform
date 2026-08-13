# Easy Auth: autenticação nativa (Microsoft Entra ID) no App Service, sem código na aplicação
# Série: artigos-app-service | Artigo: art-04-easy-auth

# ── Naming Convention ─────────────────────────────────────────────────────────
# Padrão: <tipo>-<workload>-blog-castilho-<região>
# Exemplos para este artigo:
#   app-easyauth-blog-castilho-<sufixo aleatório>

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

data "azurerm_client_config" "current" {}

# ── Web App dedicado pra demonstrar Easy Auth ────────────────────────────────

resource "random_string" "app_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "easy_auth" {
  name                = "app-easyauth-blog-castilho-${random_string.app_suffix.result}"
  resource_group_name = data.azurerm_resource_group.app_service.name
  location            = data.azurerm_resource_group.app_service.location
  service_plan_id     = data.azurerm_service_plan.app_service.id
  https_only          = true
  tags                = var.tags

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    MICROSOFT_PROVIDER_AUTHENTICATION_SECRET = var.aad_client_secret
  }

  auth_settings_v2 {
    auth_enabled           = true
    require_authentication = true
    default_provider       = "azureactivedirectory"
    unauthenticated_action  = "RedirectToLoginPage"

    active_directory_v2 {
      client_id                  = var.aad_client_id
      tenant_auth_endpoint       = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/v2.0"
      client_secret_setting_name = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
    }

    login {
      token_store_enabled = true
    }
  }
}
