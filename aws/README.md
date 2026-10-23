<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform Logo" width="80"/>
  <span style="margin: 0 20px;">+</span>
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS Logo" width="80"/>

  # AWS Terraform Repository

  <p>
    <b>Reusable Terraform modules and usage examples for Amazon Web Services (AWS).</b>
  </p>

  [![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
  [![AWS](https://img.shields.io/badge/Provider-AWS%20~%3E%206.0-232F3E?style=flat&logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)
</div>

---

## 📂 Project Structure

```text
aws/
├── terraform-vpc-modules/                     # Módulo: VPC, subnets públicas/privadas, NAT Gateway
├── terraform-eks-modules/                     # Módulo: control plane do EKS (Access Entries, OIDC opcional)
├── terraform-eks-node-group-modules/          # Módulo: Managed Node Groups (On-Demand ou Spot)
├── terraform-eks-access-entry-modules/        # Módulo: Access Entries + access policies
├── terraform-eks-pod-identity-modules/        # Módulo: IAM role para pods via EKS Pod Identity
├── terraform-eks-addon-modules/               # Módulo: add-ons gerenciados do EKS
├── terraform-eks-lb-controller-modules/       # Módulo: AWS Load Balancer Controller (Helm + Pod Identity)
├── terraform-eks-karpenter-modules/           # Módulo: Karpenter (IAM, fila de interrupção, Helm)
├── artigos-eks/                               # Série: Amazon EKS com Terraform
│   ├── eks-01-cluster-terraform/
│   ├── eks-02-managed-node-groups/
│   ├── eks-03-access-entries/
│   └── ...
└── README.md
```

## Módulos

| Módulo | Descrição |
|--------|-----------|
| [`terraform-vpc-modules`](terraform-vpc-modules/) | VPC em N AZs com subnets públicas e privadas já marcadas para load balancers do EKS |
| [`terraform-eks-modules`](terraform-eks-modules/) | Control plane do EKS com autenticação por Access Entries, endpoint restrito e política de upgrade |
| [`terraform-eks-node-group-modules`](terraform-eks-node-group-modules/) | Managed Node Group On-Demand ou Spot, com labels, taints e Session Manager |
| [`terraform-eks-access-entry-modules`](terraform-eks-access-entry-modules/) | Access Entries com access policies por cluster ou por namespace |
| [`terraform-eks-pod-identity-modules`](terraform-eks-pod-identity-modules/) | IAM role para pods com EKS Pod Identity, sem provedor OIDC |
| [`terraform-eks-addon-modules`](terraform-eks-addon-modules/) | Add-ons gerenciados com versão compatível e associação de Pod Identity |
| [`terraform-eks-lb-controller-modules`](terraform-eks-lb-controller-modules/) | AWS Load Balancer Controller via Helm, com IAM policy oficial e Pod Identity |
| [`terraform-eks-karpenter-modules`](terraform-eks-karpenter-modules/) | Karpenter: roles, fila SQS de interrupção, regras do EventBridge e Helm |

## Artigos — Série Amazon EKS com Terraform

O diretório [`artigos-eks/`](artigos-eks/) contém o código Terraform da série **Amazon EKS com Terraform**, publicada em [jeffersoncastilho.com.br](https://jeffersoncastilho.com.br).

| Artigo | Pasta | Link |
|--------|-------|------|
| EKS 01 — Cluster EKS com Terraform do zero | [`eks-01-cluster-terraform/`](artigos-eks/eks-01-cluster-terraform/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/01/20/cluster-eks/) |
| EKS 02 — Managed Node Groups On-Demand e Spot | [`eks-02-managed-node-groups/`](artigos-eks/eks-02-managed-node-groups/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/02/24/eks-managed-node-groups/) |
| EKS 03 — EKS Access Entries: o fim do aws-auth | [`eks-03-access-entries/`](artigos-eks/eks-03-access-entries/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/03/17/eks-access-entries/) |
| EKS 04 — IAM para pods com EKS Pod Identity | [`eks-04-pod-identity/`](artigos-eks/eks-04-pod-identity/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/04/14/eks-pod-identity/) |
| EKS 05 — Add-ons do EKS e EBS CSI com gp3 | [`eks-05-addons-ebs-csi/`](artigos-eks/eks-05-addons-ebs-csi/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/05/19/eks-add-ons/) |
| EKS 06 — AWS Load Balancer Controller no EKS | [`eks-06-load-balancer-controller/`](artigos-eks/eks-06-load-balancer-controller/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/06/23/aws-load-balancer-controller/) |
| EKS 07 — Karpenter no EKS com Spot | [`eks-07-karpenter/`](artigos-eks/eks-07-karpenter/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/07/14/karpenter-eks/) |
| EKS 08 — Container Insights no EKS | [`eks-08-container-insights/`](artigos-eks/eks-08-container-insights/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/08/18/eks-container-insights/) |
| EKS 09 — Upgrade do EKS sem downtime | [`eks-09-upgrade/`](artigos-eks/eks-09-upgrade/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/09/15/upgrade-eks/) |
| EKS 10 — Gateway API no EKS com ALB | [`eks-10-gateway-api/`](artigos-eks/eks-10-gateway-api/) | [Ler artigo](https://jeffersoncastilho.com.br/2026/10/23/gateway-api-eks/) |

## Uso rápido

```bash
cd artigos-eks/eks-01-cluster-terraform/
terraform init
terraform plan -var 'public_access_cidrs=["SEU_IP/32"]'
```

Os ambientes usam o perfil padrão do AWS CLI (`aws sso login` ou credenciais temporárias). Nunca versione access keys nem arquivos `.tfvars` com dados da conta.
