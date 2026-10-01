# Application Gateway v2 com WAF (OWASP managed rules) na frente de um backend
# de teste (Storage Static Website, sem VM/App Service pra manter custo mínimo).
# Série: artigos-network | Artigo: net-02-appgw-waf
#
# Refatorado para consumir módulos reutilizáveis em vez de recursos crus:
# terraform-resource-group-modules, terraform-storage-modules,
# terraform-virtual-network-modules, terraform-public-ip-modules e o novo
# terraform-appgw-waf-modules. Static website + blob do backend de teste
# continuam como recursos diretos — não fazem parte do módulo de storage
# genérico (feature de nicho, não vale generalizar no módulo compartilhado).

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

module "rg" {
  source = "../../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "blog-castilho-appgw"
  environment   = "prod"
  location      = var.location

  tags = var.tags
}

# ── Backend de teste: Storage Static Website (sem VM, custo mínimo) ──────────

module "storage_backend" {
  source = "../../terraform-storage-modules"

  name                = "stappgwbackend${random_string.storage_suffix.result}"
  resource_group_name = module.rg.name
  location            = var.location

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "backend" {
  storage_account_id = module.storage_backend.storage_account_id
  index_document     = "index.html"
}

resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = module.storage_backend.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = "<html><body><h1>Backend protegido pelo Application Gateway + WAF</h1></body></html>"

  depends_on = [azurerm_storage_account_static_website.backend]
}

# ── Rede: VNet + subnet dedicada ao Application Gateway ──────────────────────

module "vnet" {
  source = "../../terraform-virtual-network-modules"

  name                = "vnet-appgw-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location
  address_space       = [var.vnet_address_space]

  subnets = [
    { key = "appgw", name = "snet-appgw", address_prefixes = [var.appgw_subnet_prefix] },
  ]

  tags = var.tags
}

module "pip_appgw" {
  source = "../../terraform-public-ip-modules"

  name                = "pip-appgw-blog-castilho"
  resource_group_name = module.rg.name
  location            = var.location

  tags = var.tags
}

# ── WAF Policy (OWASP managed rules, modo Prevention) + Application Gateway ──
# Storage Static Website só responde em HTTPS (https_traffic_only_enabled =
# true por padrão no provider) — o Application Gateway fala HTTP com o cliente
# (porta 80, sem certificado próprio pra manter o exemplo simples) mas HTTPS
# com esse backend.

module "appgw_waf" {
  source = "../../terraform-appgw-waf-modules"

  name                 = "agw-blog-castilho"
  waf_policy_name      = "wafpolicy-blog-castilho"
  resource_group_name  = module.rg.name
  location             = var.location
  gateway_subnet_id    = module.vnet.subnets["appgw"].id
  public_ip_address_id = module.pip_appgw.id

  backend_fqdns = [
    replace(replace(module.storage_backend.primary_web_endpoint, "https://", ""), "/", ""),
  ]

  tags = var.tags
}
