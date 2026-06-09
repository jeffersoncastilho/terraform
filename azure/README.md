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
├── terraform-resource-group-modules/          # Módulo: Resource Groups padronizados
├── terraform-vm-azure-modules/                # Módulo: VMs Linux e Windows
├── terraform-virtual-network-modules/         # Módulo: Virtual Networks + subnets
├── terraform-vnet-peering-modules/            # Módulo: VNet Peering bidirecional
├── terraform-firewall-modules/                # Módulo: Azure Firewall + Firewall Policy
├── terraform-nsg-modules/                     # Módulo: Network Security Groups + regras
├── terraform-route-table-modules/             # Módulo: Route Tables + UDR
├── terraform-bastion-modules/                 # Módulo: Azure Bastion (Standard)
├── terraform-front-door-modules/              # Módulo: Azure Front Door (Standard)
├── terraform-traffic-manager-modules/         # Módulo: Azure Traffic Manager
├── terraform-private-dns-zone-modules/        # Módulo: Private DNS Zones + VNet links
├── artigos-dr/                                # Série: DR Azure e Landing Zone
│   ├── art-02-hub-spoke-terraform/
│   ├── art-03-firewall-nsg/
│   ├── art-04-bastion/
│   ├── art-05-front-door-traffic-manager/
│   ├── art-06-dns-privado/
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
| [`terraform-firewall-modules`](terraform-firewall-modules/) | Provisiona Azure Firewall Standard com Firewall Policy |
| [`terraform-nsg-modules`](terraform-nsg-modules/) | Cria NSGs com regras de segurança configuráveis |
| [`terraform-route-table-modules`](terraform-route-table-modules/) | Cria Route Tables com UDR para forçar tráfego via Firewall |
| [`terraform-bastion-modules`](terraform-bastion-modules/) | Provisiona Azure Bastion Standard sem IP público nas VMs |
| [`terraform-front-door-modules`](terraform-front-door-modules/) | Configura Azure Front Door Standard com WAF e failover |
| [`terraform-traffic-manager-modules`](terraform-traffic-manager-modules/) | Cria perfil Traffic Manager com endpoints e health checks |
| [`terraform-private-dns-zone-modules`](terraform-private-dns-zone-modules/) | Cria Private DNS Zones com links para múltiplas VNets |

## Artigos — Série DR Azure e Landing Zone

O diretório [`artigos-dr/`](artigos-dr/) contém o código Terraform da série **DR Azure e Landing Zone**, publicada em [jeffersoncastilho.com.br](https://jeffersoncastilho.com.br).

| Artigo | Pasta | Link |
|--------|-------|------|
| Art. 02 — Hub-Spoke Landing Zone com Terraform | [`art-02-hub-spoke-terraform/`](artigos-dr/art-02-hub-spoke-terraform/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/06/05/hub-spoke-landing-zone/) |
| Art. 03 — Azure Firewall e NSGs na Landing Zone | [`art-03-firewall-nsg/`](artigos-dr/art-03-firewall-nsg/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/06/06/azure-firewall-e-nsgs/) |
| Art. 04 — Azure Bastion sem IP Público | [`art-04-bastion/`](artigos-dr/art-04-bastion/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/06/07/azure-bastion-sem-ip/) |
| Art. 05 — Azure Front Door e Traffic Manager para Failover | [`art-05-front-door-traffic-manager/`](artigos-dr/art-05-front-door-traffic-manager/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/06/08/azure-front-door-failover/) |
| Art. 06 — DNS Privado Multi-Região no Azure | [`art-06-dns-privado/`](artigos-dr/art-06-dns-privado/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/06/09/dns-privado-multi-regiao/) |

## Uso rápido

```bash
cd artigos-dr/art-03-firewall-nsg/
terraform init -backend-config=backend.hcl
terraform plan -var subscription_id="$AZURE_SUBSCRIPTION_ID"
```
