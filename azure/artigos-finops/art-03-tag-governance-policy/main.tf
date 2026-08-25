# Cria uma Azure Policy (efeito "modify") que garante a tag CostCenter em todo Resource Group
# da subscription MPN, usando o módulo terraform-tag-governance-modules
# Série: artigos-finops | Artigo: art-03-tag-governance-policy

module "tag_governance" {
  source = "../../terraform-tag-governance-modules"

  subscription_id    = var.subscription_id
  location            = var.location
  policy_name         = var.policy_name
  policy_display_name = var.policy_display_name
  assignment_name     = var.assignment_name
  tag_name            = var.tag_name
  tag_default_value   = var.tag_default_value
}
