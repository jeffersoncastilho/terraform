resource "azurerm_container_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  restart_policy      = var.restart_policy
  ip_address_type     = var.ip_address_type
  subnet_ids          = length(var.subnet_ids) > 0 ? var.subnet_ids : null

  container {
    name     = var.container_name
    image    = var.image
    cpu      = var.cpu
    memory   = var.memory
    commands = var.commands

    dynamic "ports" {
      for_each = var.ports
      content {
        port     = ports.value.port
        protocol = ports.value.protocol
      }
    }

    environment_variables        = var.environment_variables
    secure_environment_variables = var.secure_environment_variables
  }

  dynamic "image_registry_credential" {
    for_each = var.image_registry_credentials
    content {
      server   = image_registry_credential.value.server
      username = image_registry_credential.value.username
      password = image_registry_credential.value.password
    }
  }

  tags = var.tags
}
