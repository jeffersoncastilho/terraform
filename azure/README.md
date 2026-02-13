<div align="center">
  <img src="https://raw.githubusercontent.com/hashicorp/terraform-website/master/content/img/logo-hashicorp.svg" alt="Terraform Logo" width="80"/>
  <span style="margin: 0 20px;">+</span>
  <img src="https://upload.wikimedia.org/wikipedia/commons/f/f1/Azure_Sky_Blue.svg" alt="Azure Logo" width="80"/>

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
├── modules/                  # 📦 Reusable Terraform modules
│   ├── azure-vnet/           #    ├── Example: Virtual Network module
│   │   ├── main.tf           #    │   ├── Primary logic
│   │   ├── variables.tf      #    │   ├── Input variables
│   │   ├── outputs.tf        #    │   └── Output values
│   │   └── README.md         #    └── Module documentation
│   └── azure-storage/        #    └── Example: Storage Account module
├── examples/                 # 🚀 Example implementations / Consumers
│   ├── vnet-simple/          #    ├── Example using the azure-vnet module
│   │   ├── main.tf
│   │   ├── providers.tf      #    ├── Azure provider configuration
│   │   └── outputs.tf
│   └── ...
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
