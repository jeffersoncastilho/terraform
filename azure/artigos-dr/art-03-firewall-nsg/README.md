# Art. 03 — Azure Firewall e NSGs na Landing Zone

Código Terraform do artigo **Azure Firewall e NSGs na Landing Zone** da série **DR Azure e Landing Zone**.

Provisiona o Azure Firewall (com Policy e IP público), Route Tables UDR e NSGs por camada de rede nas duas regiões, usando o módulo `terraform-firewall-modules`.

**Pré-requisito:** [Art. 02 — Hub-Spoke Landing Zone com Terraform](../art-02-hub-spoke-terraform/) já aplicado (VNets e subnets existentes).

## Arquitetura

```
Brazil South                              East US
────────────────────────────────────────  ──────────────────────────────────────
afw-blog-castilho-brazilsouth             afw-blog-castilho-eastus
  pip-afw-blog-castilho-brazilsouth         pip-afw-blog-castilho-eastus
  afwp-blog-castilho-brazilsouth            afwp-blog-castilho-eastus

rt-spoke-blog-castilho-brazilsouth        rt-spoke-blog-castilho-eastus
  0.0.0.0/0 → Firewall (VirtualAppliance)   0.0.0.0/0 → Firewall (VirtualAppliance)

nsg-frontend-blog-castilho-brazilsouth    nsg-frontend-blog-castilho-eastus
  allow HTTPS 443 (Internet→VNet)           allow HTTPS 443 (Internet→VNet)
  allow HTTP  80  (Internet→VNet)           allow HTTP  80  (Internet→VNet)
  deny all (4096)                           deny all (4096)

nsg-backend-blog-castilho-brazilsouth     nsg-backend-blog-castilho-eastus
  allow 8080 (10.2.1.0/24→VNet)             allow 8080 (10.3.1.0/24→VNet)
  deny Internet                             deny Internet

nsg-data-blog-castilho-brazilsouth        nsg-data-blog-castilho-eastus
  allow SQL 1433 (10.2.2.0/24→VNet)         allow SQL 1433 (10.3.2.0/24→VNet)
  deny all (4096)                           deny all (4096)

nsg-aks-blog-castilho-brazilsouth         nsg-aks-blog-castilho-eastus
  allow 443 (AzureLoadBalancer→VNet)        allow 443 (AzureLoadBalancer→VNet)
```

## Módulos utilizados

| Módulo | Caminho | Recurso |
|--------|---------|---------|
| `terraform-firewall-modules` | `../../terraform-firewall-modules` | Public IP + Firewall Policy + Azure Firewall |
| `terraform-route-table-modules` | `../../terraform-route-table-modules` | Route Table + rotas + associacoes de subnet |
| `terraform-nsg-modules` | `../../terraform-nsg-modules` | NSG + regras + associacao de subnet |

## Pré-requisitos

- Terraform >= 1.5
- Azure CLI autenticado (`az login`)
- Art. 02 já aplicado (VNets e subnets existentes)
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
key                  = "art-03-firewall-nsg.tfstate"
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
| Public IP | pip-afw-blog-castilho-brazilsouth | Brazil South |
| Firewall Policy | afwp-blog-castilho-brazilsouth | Brazil South |
| Azure Firewall | afw-blog-castilho-brazilsouth | Brazil South |
| Public IP | pip-afw-blog-castilho-eastus | East US |
| Firewall Policy | afwp-blog-castilho-eastus | East US |
| Azure Firewall | afw-blog-castilho-eastus | East US |
| Route Table | rt-spoke-blog-castilho-brazilsouth | Brazil South |
| Route Table | rt-spoke-blog-castilho-eastus | East US |
| NSG | nsg-frontend-blog-castilho-brazilsouth | Brazil South |
| NSG | nsg-frontend-blog-castilho-eastus | East US |
| NSG | nsg-backend-blog-castilho-brazilsouth | Brazil South |
| NSG | nsg-backend-blog-castilho-eastus | East US |
| NSG | nsg-data-blog-castilho-brazilsouth | Brazil South |
| NSG | nsg-data-blog-castilho-eastus | East US |
| NSG | nsg-aks-blog-castilho-brazilsouth | Brazil South |
| NSG | nsg-aks-blog-castilho-eastus | East US |

## Série: DR Azure e Landing Zone

| Artigo | Descrição |
|--------|-----------|
| [Art. 01](https://jeffersoncastilho.com.br/2026/03/31/dr-azure-e-landing-zone/) | Planejamento de DR Azure e Landing Zone |
| [Art. 02](../art-02-hub-spoke-terraform/) | Hub-Spoke Landing Zone com Terraform |
| **Art. 03 (este)** | Azure Firewall e NSGs na Landing Zone |
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
