
# Terraform
terraform {
  required_providers {
    # AWS
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }

  # Backend S3 esto lo creamos dentro de AWS 
  backend "s3" {
    bucket       = "terraform-state-devops-project-benja"
    key          = "global/s3/terraform.tfstate"
    region       = "us-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
provider "aws" {
  region = "us-east-1"
}


