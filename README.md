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

## 🤝 Contribuições

Contribuições são bem-vindas! Se você desenvolveu um módulo útil ou melhorou um existente, sinta-se à vontade para abrir um *Pull Request*.