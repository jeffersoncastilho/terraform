<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform Logo" width="80"/>
  <span style="margin: 0 20px;">+</span>
  <img src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Microsoft_Azure.svg" alt="Azure Logo" width="80"/>

  # Azure Terraform Repository

  <p>
    <b>Reusable Terraform modules and usage examples for Microsoft Azure Cloud.</b>
  </p>

  [![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
  [![Azure](https://img.shields.io/badge/Provider-AzureRM-0078D4?style=flat&logo=microsoft-azure)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
</div>

---

## 📂 Project Structure

```text
azure/
├── terraform-resource-group-modules/   # Módulo: Resource Groups padronizados
├── terraform-vm-azure-modules/         # Módulo: VMs Linux e Windows
├── terraform-virtual-network-modules/  # Módulo: Virtual Networks + subnets
├── terraform-vnet-peering-modules/     # Módulo: VNet Peering bidirecional
├── artigos-dr/                         # Série: DR Azure e Landing Zone
│   ├── art-02-hub-spoke-terraform/
│   └── ...
└── README.md
```

## Módulos

| Módulo | Descrição |
|--------|-----------|
| [`terraform-resource-group-modules`](terraform-resource-group-modules/) | Cria Resource Groups com nome padronizado por partes |
| [`terraform-vm-azure-modules`](terraform-vm-azure-modules/) | Provisiona VMs Linux e Windows com opções de disco e rede |
| [`terraform-virtual-network-modules`](terraform-virtual-network-modules/) | Cria VNets com múltiplas subnets via `for_each` |
| [`terraform-vnet-peering-modules`](terraform-vnet-peering-modules/) | Cria par de peerings bidirecionais em uma chamada |

## Artigos

O diretório [`artigos-dr/`](artigos-dr/) contém o código Terraform da série **DR Azure e Landing Zone** — cada pasta corresponde a um artigo publicado em [jeffersoncastilho.com.br](https://jeffersoncastilho.com.br).

## Uso rápido

```bash
cd artigos-dr/art-02-hub-spoke-terraform/
terraform init -backend-config=backend.hcl
terraform plan -var subscription_id="$AZURE_SUBSCRIPTION_ID"
```
