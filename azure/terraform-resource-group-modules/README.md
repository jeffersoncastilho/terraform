# Módulo Terraform - Azure Resource Group

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform Logo" width="120">
  <br>
  <em>Módulo para provisionamento padronizado de Grupos de Recursos (Resource Groups) no Microsoft Azure, com convenção de nomenclatura e tags automáticas.</em>
</p>

## 🎯 Objetivo

Este módulo simplifica a criação de um `azurerm_resource_group`, aplicando automaticamente padrões de nomenclatura (lowercase) e tags de governança.

## 🛠️ Como Usar

Para utilizar o módulo, adicione o seguinte bloco ao seu código Terraform, ajustando o `source` para o caminho correto.

### Exemplo de Uso

```hcl
module "resource_group" {
  source = "../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = "meuprojeto"
  environment   = "dev"
  location      = "Brazil South"
  
  tags = {
    CostCenter = "12345"
  }
}
```

## 📥 Entradas (Inputs)

| Nome              | Descrição                                                                 | Tipo          | Padrão | Obrigatório |
|-------------------|---------------------------------------------------------------------------|---------------|--------|:-----------:|
| `resource_type`   | Abreviação do tipo de recurso (ex: rg, st).                               | `string`      | -      |     Sim     |
| `project_name`    | Nome do projeto ou aplicação.                                             | `string`      | -      |     Sim     |
| `environment`     | Ambiente de implantação (ex: dev, prod).                                  | `string`      | -      |     Sim     |
| `location`        | A localização (região) do Azure.                                          | `string`      | -      |     Sim     |
| `location_suffix` | Abreviação da região (ex: brs).                                           | `string`      | `""`   |     Não     |
| `index`           | Sufixo numérico ou identificador.                                         | `string`      | `""`   |     Não     |
| `separator`       | Separador utilizado no nome.                                              | `string`      | `"-"`  |     Não     |
| `tags`            | Mapa de tags adicionais (convertidas para minúsculo).                     | `map(string)` | `{}`   |     Não     |

## 📚 Exemplos

Para consultar exemplos práticos de utilização deste módulo, veja abaixo a estrutura e os arquivos de configuração de um ambiente de teste.

### Estrutura de Pastas do Exemplo

```text
./resource-group/
├── locals.tf       # Chamada do módulo e definição de variáveis locais
├── providers.tf    # Configuração do backend e provider
└── README.md       # Documentação do exemplo
```

### Arquivo `locals.tf`

Este arquivo demonstra como chamar o módulo utilizando variáveis locais para definir o nome do projeto e ambiente, além de expor outputs úteis.

```hcl
locals {
  project_name = "example-project"
  environment  = "dev"
  location     = "Brazil South"
}

module "resource_group" {
  source = "../terraform-resource-group-modules"

  resource_type = "rg"
  project_name  = local.project_name
  environment   = local.environment
  location      = local.location
}

output "resource_group_name" {
  description = "O nome do Grupo de Recursos criado pelo módulo."
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "O ID completo do Grupo de Recursos."
  value       = module.resource_group.id
}
```

### Arquivo `providers.tf`

Configuração do backend remoto no Azure Storage Account e do provider AzureRM.

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-backend-tfstate"      # Substitua pelo nome do RG do seu Storage Account
    storage_account_name = "stbackendtfstate"        # Substitua pelo nome do seu Storage Account
    container_name       = "tfstate"                 # Substitua pelo nome do container
    key                  = "resource-group.tfstate"  # Nome do arquivo de estado para este projeto
  }
}

provider "azurerm" {
  features {}
}
```

## 📤 Saídas (Outputs)

| Nome       | Descrição                      |
|------------|--------------------------------|
| `id`       | O ID do Grupo de Recursos.     |
| `name`     | O nome do Grupo de Recursos.   |
| `location` | A localização do Grupo de Recursos. |

## 📂 Estrutura de Arquivos

```text
./terraform-resource-group-modules/
├── main.tf         # Definição do recurso Azure
├── variables.tf    # Variáveis de entrada do módulo
├── outputs.tf      # Saídas do módulo
├── providers.tf    # Configuração de versões dos providers
└── README.md       # Documentação do módulo
```