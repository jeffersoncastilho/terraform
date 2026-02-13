<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Terraform_Logo.svg" alt="Terraform Logo" width="80"/>
  <span style="margin: 0 20px;">+</span>
  <img src="https://upload.wikimedia.org/wikipedia/commons/5/51/Google_Cloud_logo.svg" alt="Google Cloud Logo" width="80"/>

  # GCP Terraform Repository

  <p>
    <b>Reusable Terraform modules and usage examples for Google Cloud Platform (GCP).</b>
  </p>

  [![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
  [![Google Cloud](https://img.shields.io/badge/Provider-GCP-4285F4?style=flat&logo=google-cloud&logoColor=white)](https://registry.terraform.io/providers/hashicorp/google/latest)
</div>

---

## 📂 Project Structure

The repository follows the **Standard Module Structure**:

```text
.
├── modules/                  # 📦 Reusable Terraform modules
│   ├── gcp-vpc/              #    ├── Example: VPC module
│   │   ├── main.tf           #    │   ├── Primary logic
│   │   ├── variables.tf      #    │   ├── Input variables
│   │   ├── outputs.tf        #    │   └── Output values
│   │   └── README.md         #    └── Module documentation
│   └── gcp-gke/              #    └── Example: GKE Cluster module
├── examples/                 # 🚀 Example implementations / Consumers
│   ├── vpc-simple/           #    ├── Example using the gcp-vpc module
│   │   ├── main.tf
│   │   ├── providers.tf      #    ├── GCP provider configuration
│   │   └── outputs.tf
│   └── ...
└── README.md
```

## 🔄 Workflow

1.  **Modules (`modules/`)**:
    Develop reusable logic in the `modules/` directory.

2.  **Examples (`examples/`)**:
    Create scenarios in `examples/` that call the modules using `source = "../../modules/<module-name>"`.

## 🚀 Usage

To run an example:

```bash
cd examples/vpc-simple
terraform init
terraform plan
terraform apply
```