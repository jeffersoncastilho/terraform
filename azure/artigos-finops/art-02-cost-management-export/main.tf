# Cria um storage account + container e um Cost Management Export mensal na subscription MPN, exportando custos automaticamente em CSV, usando o módulo terraform-cost-export-modules
# Série: artigos-finops | Artigo: art-02-cost-management-export

# ── Naming Convention ─────────────────────────────────────────────────────────
# Padrão: <tipo>-<workload>-blog-castilho-<região>
# Storage accounts não aceitam hífen, então usam o padrão compacto: st<workload>blogcastilho

locals {
  workload              = "finops"
  resource_group_name   = "rg-${local.workload}-blog-castilho-eastus"
  storage_account_name  = "st${local.workload}blogcastilho"
  export_name            = "export-${local.workload}-blog-castilho"
}

# ── Recursos ──────────────────────────────────────────────────────────────────

module "cost_export" {
  source = "../../terraform-cost-export-modules"

  name                  = local.export_name
  subscription_id       = var.subscription_id
  resource_group_name   = local.resource_group_name
  location              = var.location
  storage_account_name  = local.storage_account_name
  container_name        = var.container_name
  recurrence_type       = var.recurrence_type
  start_date            = var.start_date
  end_date              = var.end_date
}
