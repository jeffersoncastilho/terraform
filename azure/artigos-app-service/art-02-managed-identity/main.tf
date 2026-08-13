# Managed Identity (User-Assigned) do Web App acessando Key Vault via RBAC
# Série: artigos-app-service | Artigo: art-02-managed-identity

# ── Naming Convention ─────────────────────────────────────────────────────────
# Padrão: <tipo>-<workload>-blog-castilho-<região>
# Exemplos para este artigo:
#   id-app-service-blog-castilho-eus
#   kv-appsvc-castilho-<sufixo aleatório>

locals {
  workload    = "app-service"
  name_suffix = "blog-castilho-eus"
}

# ── Recursos existentes do art-01 (fundação da série) ─────────────────────────

data "azurerm_resource_group" "app_service" {
  name = "rg-${local.workload}-${local.name_suffix}"
}

data "azurerm_client_config" "current" {}

# ── Sufixo aleatório pro nome do Key Vault (precisa ser globalmente único) ────

resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

# ── User-Assigned Managed Identity ────────────────────────────────────────────

module "identity" {
  source              = "../../terraform-managed-identity-modules"
  name                = "id-${local.workload}-${local.name_suffix}"
  resource_group_name = data.azurerm_resource_group.app_service.name
  location            = data.azurerm_resource_group.app_service.location
  tags                = var.tags
}

# ── Key Vault (autorização via RBAC do Azure AD) ──────────────────────────────

module "keyvault" {
  source                    = "../../terraform-keyvault-modules"
  name                      = "kv-appsvc-castilho-${random_string.kv_suffix.result}"
  resource_group_name       = data.azurerm_resource_group.app_service.name
  location                  = data.azurerm_resource_group.app_service.location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
  tags                      = var.tags
}

# ── Role Assignment: identity pode ler segredos do Key Vault ─────────────────

module "role_assignment" {
  source                           = "../../terraform-role-assignment-modules"
  scope                            = module.keyvault.key_vault_id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = module.identity.principal_id
  skip_service_principal_aad_check = true
  depends_on                       = [module.identity, module.keyvault]
}

# ── Segredo de exemplo, lido pelo Web App via Managed Identity ───────────────

resource "azurerm_key_vault_secret" "demo" {
  name         = "demo-connection-string"
  value        = "Server=demo;Database=demo;Trusted_Connection=True;"
  key_vault_id = module.keyvault.key_vault_id

  depends_on = [module.role_assignment]
}
