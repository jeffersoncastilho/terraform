# Repositório de Códigos para AWS
<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform Logo" width="80"/>
  <span style="margin: 0 20px;">+</span>
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS Logo" width="80"/>

<p align="center">
  <img src="https://jeffersoncastilho.com.br/wp-content/uploads/2026/01/aws-logo.png" alt="AWS Logo" width="600">
  <br>
  <br>
  <em>Scripts, automações e templates de infraestrutura como código para o ecossistema AWS.</em>
</p>
  # AWS Terraform Repository

<!-- 
  IMPORTANTE: Para os badges funcionarem, substitua 'SEU_USUARIO/SEU_REPOSITORIO' pelo caminho do seu repositório no GitHub.
  Exemplo: 'microsoft/vscode'
-->
<p align="center">
  <img src="https://img.shields.io/github/last-commit/SEU_USUARIO/SEU_REPOSITORIO?style=for-the-badge&logo=github&label=Último%20Commit" alt="Último Commit">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="Licença MIT">
</p>
  <p>
    <b>Reusable Terraform modules and usage examples for Amazon Web Services (AWS).</b>
  </p>

## 🚀 Tecnologias
  [![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
  [![AWS](https://img.shields.io/badge/Provider-AWS-232F3E?style=flat&logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)
</div>

Este repositório contém exemplos e utilitários construídos com as seguintes tecnologias:
---

<p align="center">
  <a href="https://aws.amazon.com/"><img src="https://img.shields.io/badge/AWS-%23232F3E.svg?style=for-the-badge&logo=amazon-aws&logoColor=white" alt="AWS"></a>
  <a href="https://www.python.org/"><img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"></a>
  <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/Shell_Script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell Script"></a>
</p>
## 📂 Project Structure

## 📂 Estrutura
The repository follows the **Standard Module Structure**, organizing resources by AWS products:

O conteúdo está organizado por tecnologia:
```text
.
├── modules/                  # 📦 Reusable Terraform modules
│   ├── aws-vpc/              #    ├── Network: VPC, Subnets, Route Tables, IGW
│   ├── aws-ec2/              #    ├── Compute: EC2 Instances, Security Groups, ALBs
│   ├── aws-s3/               #    ├── Storage: S3 Buckets, Policies, Lifecycle Rules
│   ├── aws-rds/              #    ├── Database: RDS Instances, Parameter Groups
│   ├── aws-eks/              #    ├── Containers: EKS Cluster, Node Groups
│   └── aws-lambda/           #    └── Serverless: Lambda Functions, Layers
├── examples/                 # 🚀 Example implementations / Consumers
│   ├── vpc-standard/         #    ├── Standard VPC architecture
│   ├── web-cluster/          #    ├── HA Web Server Cluster (EC2 + ALB + ASG)
│   ├── serverless-api/       #    ├── API Gateway + Lambda + DynamoDB
│   └── eks-cluster/          #    └── Managed Kubernetes Cluster
└── README.md
```

-   **`/python`**: Scripts em Python para automação de tarefas na AWS com Boto3.
-   **`/shell`**: Scripts de linha de comando para automações e tarefas de administração.
## 🔄 Workflow

## Como Usar
1.  **Modules (`modules/`)**:
    Develop reusable logic in the `modules/` directory. Each module should be self-contained.

Cada diretório conterá seu próprio `README.md` com instruções específicas sobre como utilizar os códigos e scripts contidos nele. Sinta-se à vontade para explorar as pastas.
2.  **Examples (`examples/`)**:
    Create scenarios in `examples/` that call the modules using `source = "../../modules/<module-name>"`.

## 📜 Versionamento e Changelog
## 🚀 Usage

As mudanças e novas funcionalidades neste projeto serão documentadas no arquivo `CHANGELOG.md`.
To run an example:

## 🤝 Contribuições

Contribuições são muito bem-vindas! Sinta-se à vontade para abrir uma *issue* para relatar um problema ou enviar um *pull request* com melhorias.
```bash
cd examples/vpc-standard
terraform init
terraform plan
terraform apply
```