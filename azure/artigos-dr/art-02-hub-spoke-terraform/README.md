# Art. 02 — Hub-Spoke Landing Zone com Terraform

Código Terraform do artigo **[Hub-Spoke Landing Zone com Terraform](https://jeffersoncastilho.com.br/microsoft-azure/hub-spoke-landing-zone/)** da série **DR Azure e Landing Zone**.

Provisiona a topologia Hub-Spoke multi-região no Azure com 4 VNets, 4 Resource Groups e 6 peerings, usando os módulos compartilhados da pasta `azure/`.

## Arquitetura

```
Brazil South                         East US
──────────────────────────────────   ──────────────────────────────────
vnet-hub-blog-castilho-brazilsouth   vnet-hub-blog-castilho-eastus
  ├── AzureFirewallSubnet 10.0.0.0/26   ├── AzureFirewallSubnet 10.1.0.0/26
  ├── GatewaySubnet       10.0.0.64/27  ├── GatewaySubnet       10.1.0.64/27
  ├── AzureBastionSubnet  10.0.0.128/26 ├── AzureBastionSubnet  10.1.0.128/26
  └── snet-management     10.0.0.192/27 └── snet-management     10.1.0.192/27
         │  Global Peering (hub-hub)  │
vnet-spoke-blog-castilho-brazilsouth  vnet-spoke-blog-castilho-eastus
  ├── snet-frontend  10.2.1.0/24       ├── snet-frontend  10.3.1.0/24
  ├── snet-backend   10.2.2.0/24       ├── snet-backend   10.3.2.0/24
  ├── snet-data      10.2.3.0/24       ├── snet-data      10.3.3.0/24
  └── snet-aks       10.2.4.0/22       └── snet-aks       10.3.4.0/22
```

## Módulos utilizados

| Módulo | Caminho | Recurso |
|--------|---------|---------|
| `terraform-resource-group-modules` | `../../terraform-resource-group-modules` | 4 Resource Groups |
| `terraform-virtual-network-modules` | `../../terraform-virtual-network-modules` | 4 Virtual Networks + subnets |
| `terraform-vnet-peering-modules` | `../../terraform-vnet-peering-modules` | 6 VNet Peerings (3 pares bidirecionais) |

## Pré-requisitos

- Terraform >= 1.5
- Azure CLI autenticado (`az login`)
- Storage Account para o Terraform state (backend azurerm)
- Variáveis de ambiente definidas:

```bash
export AZURE_SUBSCRIPTION_ID="<sua-subscription-id>"
export TF_STORAGE_ACCOUNT="<storage-account-do-tfstate>"
export TF_STORAGE_RG="<resource-group-do-tfstate>"
```

## Deploy

```bash
# 1. Criar backend.hcl (não commitado)
cat > backend.hcl <<EOF
resource_group_name  = "$TF_STORAGE_RG"
storage_account_name = "$TF_STORAGE_ACCOUNT"
container_name       = "tfstate"
key                  = "art-02-hub-spoke-terraform.tfstate"
EOF

# 2. Init
terraform init -backend-config=backend.hcl

# 3. Plan
terraform plan -var subscription_id="$AZURE_SUBSCRIPTION_ID"

# 4. Apply
terraform apply -var subscription_id="$AZURE_SUBSCRIPTION_ID"
```

## Limpeza

```bash
terraform destroy -var subscription_id="$AZURE_SUBSCRIPTION_ID"
```

## Recursos criados

| Tipo | Nome | Região |
|------|------|--------|
| Resource Group | rg-blog-castilho-network-brazilsouth | Brazil South |
| Resource Group | rg-blog-castilho-network-eastus | East US |
| Resource Group | rg-blog-castilho-workload-brazilsouth | Brazil South |
| Resource Group | rg-blog-castilho-workload-eastus | East US |
| Virtual Network | vnet-hub-blog-castilho-brazilsouth | Brazil South |
| Virtual Network | vnet-hub-blog-castilho-eastus | East US |
| Virtual Network | vnet-spoke-blog-castilho-brazilsouth | Brazil South |
| Virtual Network | vnet-spoke-blog-castilho-eastus | East US |
| VNet Peering | peer-hub-brazilsouth-to-hub-eastus | Global |
| VNet Peering | peer-hub-eastus-to-hub-brazilsouth | Global |
| VNet Peering | peer-hub-to-spoke-brazilsouth | Brazil South |
| VNet Peering | peer-spoke-to-hub-brazilsouth | Brazil South |
| VNet Peering | peer-hub-to-spoke-eastus | East US |
| VNet Peering | peer-spoke-to-hub-eastus | East US |

## Série: DR Azure e Landing Zone

| Artigo | Descrição |
|--------|-----------|
| [Art. 01](https://jeffersoncastilho.com.br/2026/03/31/dr-azure-e-landing-zone/) | Planejamento de DR Azure e Landing Zone |
| **Art. 02 (este)** | Hub-Spoke Landing Zone com Terraform |
| Art. 03 | Azure Firewall e NSGs na Landing Zone |
| Art. 04 | Azure Bastion na Landing Zone sem IP Público |
| Art. 05 | Azure Front Door e Traffic Manager para Failover |
| Art. 06 | DNS Privado Multi-Região no Azure |
| Art. 07 | Azure Site Recovery para VMs Multi-Região |
| Art. 08 | Azure Storage com Geo-Replicação para DR |
| Art. 09 | AKS Multi-Região com Failover no Azure |
| Art. 10 | Velero no AKS para Backup e Restore Cross-Region |
| Art. 11 | Runbooks de Failover no Azure Automation |
| Art. 12 | Simular um DR no Azure sem Impacto em Produção |
| Art. 13 | Monitoramento do DR no Azure com Azure Monitor |
