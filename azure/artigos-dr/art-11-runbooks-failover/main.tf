# ── Data Sources ───────────────────────────────────────────────────────────────

data "azurerm_resource_group" "this" {
  name = "rg-blog-castilho-workload-brazilsouth"
}

# ── Key Vault — segredos para runbooks e SP do Grafana ────────────────────────

module "key_vault" {
  source              = "../../terraform-keyvault-modules"
  name                = "kv-blog-castilho"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  tenant_id           = var.tenant_id
  tags                = var.tags
}

# ── Automation Account + Runbook de Failover ──────────────────────────────────

module "automation" {
  source              = "../../terraform-automation-modules"
  name                = "aa-blog-castilho"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  subscription_id     = var.subscription_id
  runbook_name        = "failover-orchestrator"
  runbook_type        = "PowerShell"
  runbook_content     = file("${path.module}/00-failover-orchestrator.ps1")
  create_webhook      = true
  webhook_expiry_time = "2027-12-31T00:00:00Z"
  tags                = var.tags
}
