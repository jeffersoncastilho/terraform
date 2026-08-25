# Módulo: terraform-cost-export-modules
# Provider: azure
# Cria um Storage Account + Container e um Cost Management Export agendado, exportando dados de custo (CSV) automaticamente para o storage

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_subscription_cost_management_export" "this" {
  name                          = var.name
  subscription_id               = "/subscriptions/${var.subscription_id}"
  recurrence_type               = var.recurrence_type
  recurrence_period_start_date  = var.start_date
  recurrence_period_end_date    = var.end_date
  active                        = true

  export_data_storage_location {
    container_id      = azurerm_storage_container.this.id
    root_folder_path  = var.root_folder_path
  }

  export_data_options {
    type       = var.export_type
    time_frame = var.time_frame
  }
}
