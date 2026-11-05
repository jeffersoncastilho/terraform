# Azure Functions Premium (Elastic Premium) com integração de VNet — a Function
# App consegue chamar recursos privados (banco, storage com Private Endpoint,
# etc.) da VNet, algo que o plano Consumption não permite.
# Série: artigos-paas | Artigo: paas-01-functions-premium-vnet
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-virtual-network-modules (com o
# suporte a delegation por subnet, já usado pelo net-03), terraform-storage-modules
# e o novo terraform-functions-modules.
#
# Aplicado, testado e destruído em 2026-09-08 (7 recursos). Sem cota de EP1 em
# eastus nessa subscription: o teste rodou em centralus (variável location).
# Plano Elastic Premium EP1 custa proporcionalmente por hora (~US$ 0,20/h) —
# não é gratuito como os artigos net-01/03/06/07, mas bem mais barato que
# VPN Gateway ou DDoS Protection Standard.

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-functions"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

# ── Rede: VNet + subnet delegada ao App Service (Functions Premium usa o
# mesmo mecanismo de integração de VNet regional do App Service) ─────────────

module "vnet" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-functions-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.vnet_address_space]

  subnets = [
    {
      key              = "functions"
      name             = "snet-functions"
      address_prefixes = [var.functions_subnet_prefix]
      delegation = {
        name                       = "functions-delegation"
        service_delegation_name    = "Microsoft.Web/serverFarms"
        service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    },
  ]

  tags = var.tags
}

# ── Storage Account: obrigatório para qualquer Function App ──────────────────

module "storage_functions" {
  source = "../../terraform-storage-modules"

  name                = "stfuncsblog${random_string.storage_suffix.result}"
  resource_group_name = module.rg.name
  location            = var.location

  tags = var.tags
}

# ── App Service Plan Elastic Premium (EP1) + Function App com integração
# de VNet regional ─────────────────────────────────────────────────────────

module "functions" {
  source = "../../terraform-functions-modules"

  name                       = "func-blog-castilho-${random_string.storage_suffix.result}"
  plan_name                  = "plan-functions-blog-castilho"
  resource_group_name        = module.rg.name
  location                   = var.location
  sku_name                   = "EP1"
  storage_account_name       = module.storage_functions.storage_account_name
  storage_account_access_key = module.storage_functions.primary_access_key
  subnet_id                  = module.vnet.subnets["functions"].id
  node_version               = "20"

  tags = var.tags
}
