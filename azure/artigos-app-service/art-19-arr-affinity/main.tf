# ARR Affinity (session affinity) no App Service multi-instância
# Série: artigos-app-service | Artigo: art-19-arr-affinity

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
