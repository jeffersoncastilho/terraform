# Custom RBAC role pro App Service: permissão mínima (read + restart) atribuída à Managed Identity do art-02
# Série: artigos-app-service | Artigo: art-03-rbac-app-service

# ── Naming Convention ─────────────────────────────────────────────────────────
# Padrão: <tipo>-<workload>-blog-castilho-<região>
# Exemplos para este artigo:
#   App Service Restart Operator (custom role definition)

locals {
  workload    = "app-service"
  name_suffix = "blog-castilho-eus"
}

# ── Recursos existentes das etapas anteriores ────────────────────────────────

data "azurerm_resource_group" "app_service" {
  name = "rg-${local.workload}-${local.name_suffix}"
}

data "azurerm_user_assigned_identity" "app_identity" {
  name                = "id-${local.workload}-${local.name_suffix}"
  resource_group_name = data.azurerm_resource_group.app_service.name
}

data "azurerm_subscription" "current" {}

# ── Custom Role Definition: só leitura + restart do Web App ──────────────────

resource "azurerm_role_definition" "app_service_operator" {
  name        = "App Service Restart Operator - blog-castilho"
  scope       = data.azurerm_resource_group.app_service.id
  description = "Permite ler e reiniciar Web Apps, sem acesso a configurações ou dados."

  permissions {
    actions = [
      "Microsoft.Web/sites/read",
      "Microsoft.Web/sites/restart/action",
      "Microsoft.Web/sites/config/list/action",
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_resource_group.app_service.id,
  ]
}

# ── Atribui o papel custom à Managed Identity criada no art-02 ───────────────

module "role_assignment" {
  source                           = "../../terraform-role-assignment-modules"
  scope                            = data.azurerm_resource_group.app_service.id
  role_definition_name             = azurerm_role_definition.app_service_operator.name
  principal_id                     = data.azurerm_user_assigned_identity.app_identity.principal_id
  skip_service_principal_aad_check = true
  depends_on                       = [azurerm_role_definition.app_service_operator]
}
