# Fundação da série: Resource Group + App Service Plan (Linux) + Linux Web App base, reutilizados pelos próximos 28 artigos
# Série: artigos-app-service | Artigo: art-01-planejamento

# ── Naming Convention ─────────────────────────────────────────────────────────
# Padrão: <tipo>-<workload>-blog-castilho-<região>
# Exemplos para este artigo:
#   rg-app-service-blog-castilho-eus
#   plan-app-service-blog-castilho-eus
#   app-app-service-blog-castilho-<sufixo aleatório>

locals {
  workload    = "app-service"
  name_suffix = "blog-castilho-eus"
}

# ── Sufixo aleatório pro nome do Web App (precisa ser globalmente único) ──────

resource "random_string" "app_suffix" {
  length  = 6
  special = false
  upper   = false
}

# ── Resource Group ────────────────────────────────────────────────────────────

module "rg" {
  source          = "../../terraform-resource-group-modules"
  resource_type   = "rg"
  project_name    = "app-service-blog-castilho"
  environment     = ""
  location_suffix = "eus"
  location        = var.location
  tags            = var.tags
}

# ── App Service Plan + Linux Web App base ─────────────────────────────────────

module "appservice" {
  source              = "../../terraform-appservice-modules"
  plan_name           = "plan-${local.workload}-${local.name_suffix}"
  app_name            = "app-${local.workload}-blog-castilho-${random_string.app_suffix.result}"
  resource_group_name = module.rg.name
  location            = var.location
  sku_name            = "B1"

  application_stack = {
    dotnet_version = "8.0"
  }

  tags       = var.tags
  depends_on = [module.rg]
}
