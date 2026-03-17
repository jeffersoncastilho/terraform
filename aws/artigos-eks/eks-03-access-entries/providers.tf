terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Em uso real, guarde o state num bucket S3 com lock nativo (use_lockfile):
  # backend "s3" {
  #   bucket       = "meu-bucket-de-tfstate"
  #   key          = "eks-lab/terraform.tfstate"
  #   region       = "us-east-1"
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}
