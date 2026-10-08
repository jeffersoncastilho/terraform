# O plano em si não está ligado a uma única região — pode proteger IPs de
# VNets em regiões diferentes, todos cobertos pela mesma taxa mensal fixa.
resource "azurerm_network_ddos_protection_plan" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
