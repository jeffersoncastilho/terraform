resource "azurerm_public_ip" "this" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "${var.vm_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_network_security_group" "this" {
  count               = length(var.nsg_rules) > 0 ? 1 : 0
  name                = "${var.vm_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.this[0].id : null
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "this" {
  count                     = length(var.nsg_rules) > 0 ? 1 : 0
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

resource "azurerm_linux_virtual_machine" "this" {
  count               = var.os_type == "linux" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  count               = var.os_type == "windows" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "custom_script" {
  count                = var.enable_custom_script ? 1 : 0
  name                 = "${var.vm_name}-custom-script"
  virtual_machine_id   = var.os_type == "linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "fileUris": ${jsonencode(var.custom_script_file_uris)},
        "commandToExecute": "${var.custom_script_command}"
    }
SETTINGS

  tags = var.tags
}