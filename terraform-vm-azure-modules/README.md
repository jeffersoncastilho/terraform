# Repositório de Módulos Terraform

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform Logo" width="120">
  <br>
  <em>Central de módulos, recursos e templates de Infraestrutura como Código (IaC) multi-cloud para AWS, Azure e GCP.</em>
</p>

## 🎯 Objetivo

Este repositório tem como objetivo fornecer uma biblioteca de **módulos reutilizáveis** e exemplos de recursos Terraform para os principais provedores de nuvem. O foco é padronizar o provisionamento de infraestrutura seguindo as melhores práticas de cada cloud provider.

## 🚀 Provedores Suportados

As soluções abrangem os três principais provedores de nuvem pública:

<p align="center">
  <img src="https://jeffersoncastilho.com.br/wp-content/uploads/2026/01/aws-logo.png" alt="AWS Logo" height="60">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://jeffersoncastilho.com.br/wp-content/uploads/2026/01/microsoft-azure-logo.png" alt="Microsoft Azure Logo" height="60">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/5/51/Google_Cloud_logo.svg" alt="Google Cloud Platform Logo" height="60">
</p>

## 📂 Estrutura do Repositório

O conteúdo está organizado por provedor (Provider), facilitando a localização dos módulos específicos:

*   **`/aws`**: Módulos e recursos para Amazon Web Services (EC2, S3, RDS, VPC, etc.).
*   **`/azure`**: Módulos e recursos para Microsoft Azure (VMs, AKS, VNet, Storage Accounts, etc.).
*   **`/gcp`**: Módulos e recursos para Google Cloud Platform (Compute Engine, GKE, Cloud Storage, etc.).

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

O módulo disponibiliza as seguintes funcionalidades:

*   **VM Linux (Ubuntu)**: Provisiona uma VM com Ubuntu 22.04 LTS.
*   **Rede**: Cria automaticamente a interface de rede (NIC).
*   **IP Público**: Opcional (`enable_public_ip`), cria um IP público dinâmico.
*   **Security Group (NSG)**: Opcional, permite definir regras de entrada/saída dinamicamente via `nsg_rules`.
*   **SSH Key**: Configuração de acesso via chave pública SSH.
*   **Custom Script**: Opcional (`enable_custom_script`), permite executar scripts de inicialização na VM.
*   **Tags**: Suporte completo a tags nos recursos criados.

## 🤝 Contribuições

Contribuições são bem-vindas! Se você desenvolveu um módulo útil ou melhorou um existente, sinta-se à vontade para abrir um *Pull Request*.