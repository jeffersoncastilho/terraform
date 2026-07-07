terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  # State local neste ambiente standalone (lab de observabilidade).
  # Para state remoto, adicione:  backend "azurerm" {}  e use backend.hcl.example
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
