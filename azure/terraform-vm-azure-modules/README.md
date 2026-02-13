# Módulo Terraform - Azure VM (Linux & Windows)

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform Logo" width="120">
  <br>
  <em>Módulo para provisionamento de Máquinas Virtuais (Linux e Windows) no Microsoft Azure.</em>
</p>

## 🎯 Objetivo

Este módulo tem como objetivo facilitar a criação de Máquinas Virtuais no Azure, encapsulando a complexidade da configuração de recursos de rede (NIC, IP Público, NSG) e extensões, seguindo as melhores práticas.

## 🛠️ Como Usar

Para utilizar um módulo em seu projeto, referencie o caminho local ou o repositório Git no seu bloco `module`.

### Exemplo de Criação de VM na Azure

Abaixo está um exemplo completo, incluindo a criação do Resource Group e VNet necessários:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-exemplo-vm"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-exemplo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "subnet-internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "linux_vm" {
  source = "./terraform-vm-azure-modules" # Ajuste o caminho conforme a localização do módulo

  vm_name             = "vm-ubuntu-01"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  subnet_id           = azurerm_subnet.example.id
  vm_size             = "Standard_B2s"
  admin_username      = "azureuser"
  public_key          = file("~/.ssh/id_rsa.pub")
  enable_public_ip    = true

  nsg_rules = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  tags = {
    Environment = "Demo"
  }
}
```

### 📋 Features do Módulo Azure VM

O módulo disponibiliza as seguintes funcionalidades para **Linux** e **Windows**:

*   **Multi-OS**: Suporte a Linux e Windows via variável `os_type`.
*   **Imagem Customizável**: Defina Publisher, Offer, SKU e Version da imagem.
*   **Rede**: Cria automaticamente a interface de rede (NIC).
*   **IP Público**: Opcional (`enable_public_ip`), cria um IP público dinâmico.
*   **Security Group (NSG)**: Opcional, permite definir regras de entrada/saída dinamicamente via `nsg_rules`.
*   **Autenticação**: SSH Key (Linux) ou Senha (Windows).
*   **Custom Script**: Opcional (`enable_custom_script`), permite executar scripts de inicialização na VM.
*   **Tags**: Suporte completo a tags nos recursos criados.

## 🤝 Contribuições

Contribuições são bem-vindas! Se você desenvolveu um módulo útil ou melhorou um existente, sinta-se à vontade para abrir um *Pull Request*.