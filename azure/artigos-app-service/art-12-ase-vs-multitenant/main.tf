# App Service Environment v3 vs multi-tenant: quando usar cada um
# Série: artigos-app-service | Artigo: art-12-ase-vs-multitenant

# ── Naming Convention ─────────────────────────────────────────────────────────
# Padrão: <tipo>-<workload>-blog-castilho-<região>
# Exemplos para este artigo:
#   rg-app-service-blog-castilho-eus
#   vnet-app-service-blog-castilho-eus
#   snet-app-service-blog-castilho-eus
#   nsg-app-service-blog-castilho-eus

locals {
  workload    = "app-service"
  name_suffix = "blog-castilho-eus"
}

# ── Recursos ──────────────────────────────────────────────────────────────────

# Adicione os módulos e recursos aqui seguindo o padrão de naming acima
