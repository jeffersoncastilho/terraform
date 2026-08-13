# Módulo: terraform-appservice-modules
# Provider: azure
# App Service Plan (Linux) + Linux Web App base, reutilizado pela série completa de artigos de App Service

resource "azurerm_service_plan" "this" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true
  app_settings        = var.app_settings
  tags                = var.tags

  site_config {
    always_on = var.always_on

    application_stack {
      node_version      = var.application_stack.node_version
      python_version    = var.application_stack.python_version
      dotnet_version    = var.application_stack.dotnet_version
      docker_image_name = var.application_stack.docker_image_name
    }
  }

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : [var.identity_type]
    content {
      type = identity.value
    }
  }
}
