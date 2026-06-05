# artigos-dr — Série: DR Azure e Landing Zone

Código Terraform da série **DR Azure e Landing Zone** publicada em [jeffersoncastilho.com.br](https://jeffersoncastilho.com.br).

Cada pasta corresponde a um artigo da série e usa os módulos reutilizáveis da raiz do repositório (`azure/terraform-*-modules`).

## Artigos da Série

| Artigo | Pasta | Descrição |
|--------|-------|-----------|
| [Art. 01](https://jeffersoncastilho.com.br/2026/03/31/dr-azure-e-landing-zone/) | — | Planejamento de DR Azure e Landing Zone |
| [Art. 02](https://jeffersoncastilho.com.br/microsoft-azure/hub-spoke-landing-zone/) | `art-02-hub-spoke-terraform/` | Hub-Spoke Landing Zone com Terraform |
| Art. 03 | `art-03-firewall-nsg/` | Azure Firewall e NSGs na Landing Zone |
| Art. 04 | `art-04-bastion/` | Azure Bastion na Landing Zone sem IP Público |
| Art. 05 | `art-05-front-door-traffic-manager/` | Azure Front Door e Traffic Manager para Failover |
| Art. 06 | `art-06-dns-privado/` | DNS Privado Multi-Região no Azure |
| Art. 07 | `art-07-site-recovery/` | Azure Site Recovery para VMs Multi-Região |
| Art. 08 | `art-08-storage-replication/` | Azure Storage com Geo-Replicação para DR |
| Art. 09 | `art-09-aks-multi-regiao/` | AKS Multi-Região com Failover no Azure |
| Art. 10 | `art-10-velero-aks/` | Velero no AKS para Backup e Restore Cross-Region |
| Art. 11 | `art-11-runbooks-failover/` | Runbooks de Failover no Azure Automation |
| Art. 12 | `art-12-simulando-dr/` | Simular um DR no Azure sem Impacto em Produção |
| Art. 13 | `art-13-monitoramento/` | Monitoramento do DR no Azure com Azure Monitor |

## Pré-requisitos

- Terraform >= 1.5
- Azure CLI autenticado (`az login`)
- Storage Account para o Terraform state (veja `bootstrap/` nos scripts privados)
- Variáveis de ambiente:

```bash
export AZURE_SUBSCRIPTION_ID="<sua-subscription-id>"
export TF_STORAGE_ACCOUNT="<storage-account-do-tfstate>"
export TF_STORAGE_RG="<resource-group-do-tfstate>"
```

## Estrutura padrão de cada artigo

```text
art-XX-nome/
├── main.tf          # Recursos do artigo (usa módulos da raiz)
├── variables.tf     # Variáveis de entrada
├── providers.tf     # Provider azurerm + backend azurerm {}
├── outputs.tf       # Outputs relevantes
└── README.md        # Arquitetura, recursos criados e instruções de deploy
```

## Módulos utilizados

Os artigos referenciam os módulos da raiz via caminho relativo:

| Módulo | Caminho |
|--------|---------|
| `terraform-resource-group-modules` | `../../terraform-resource-group-modules` |
| `terraform-virtual-network-modules` | `../../terraform-virtual-network-modules` |
| `terraform-vnet-peering-modules` | `../../terraform-vnet-peering-modules` |

## Deploy de um artigo

```bash
cd art-XX-nome/

# Criar backend.hcl (não commitado — já no .gitignore)
cat > backend.hcl <<EOF
resource_group_name  = "$TF_STORAGE_RG"
storage_account_name = "$TF_STORAGE_ACCOUNT"
container_name       = "tfstate"
key                  = "art-XX-nome.tfstate"
EOF

terraform init -backend-config=backend.hcl
terraform plan  -var subscription_id="$AZURE_SUBSCRIPTION_ID"
terraform apply -var subscription_id="$AZURE_SUBSCRIPTION_ID"
```
