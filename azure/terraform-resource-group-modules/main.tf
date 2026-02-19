# main.tf

locals {
  # Constrói o nome juntando as partes não vazias com o separador
  name = lower(join(var.separator, compact([
    var.resource_type,
    var.project_name,
    var.environment,
    var.location_suffix,
    var.index
  ])))

  # Normaliza as tags para letras minúsculas e adiciona tag de gerenciamento
  tags = merge(
    { "managed-by" = "terraform" },
    { for k, v in var.tags : lower(k) => lower(v) }
  )
}

resource "azurerm_resource_group" "this" {
  name     = local.name
  location = var.location
  tags     = local.tags
}