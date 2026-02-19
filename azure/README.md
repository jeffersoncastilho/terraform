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

The repository follows the **Standard Module Structure**:

```text
.
├── terraform-resource-group-modules/  # 📦 Resource Group Module: Standardized RG provisioning
├── terraform-vm-azure-modules/        # 📦 Virtual Machine Module: Linux & Windows VMs
└── README.md
```

## Workflow

1. **Modules**: Develop reusable logic in the `modules/` directory.
2. **Examples**: Create scenarios in `examples/` that call the modules using `source = "../../modules/<module-name>"`.

## Usage

To run an example:

```bash
cd examples/vnet-simple
terraform init
terraform plan
terraform apply
```
