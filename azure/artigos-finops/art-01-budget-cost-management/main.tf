# Cria um budget mensal de R$20 na subscription MPN com alertas em 50%, 80% e 100% via Cost Management, usando o módulo terraform-budget-modules
# Série: artigos-finops | Artigo: art-01-budget-cost-management

# ── Naming Convention ─────────────────────────────────────────────────────────
# Padrão: <tipo>-<workload>-blog-castilho-<região>
# Budgets são recursos de subscription (não regionais), então o sufixo de região é omitido:
#   budget-finops-blog-castilho

locals {
  workload = "finops"
  name     = "budget-${local.workload}-blog-castilho"
}

# ── Recursos ──────────────────────────────────────────────────────────────────

module "budget" {
  source = "../../terraform-budget-modules"

  name            = local.name
  subscription_id = var.subscription_id
  amount          = var.amount
  thresholds      = var.thresholds
  contact_emails  = var.contact_emails
  start_date      = var.start_date
}
