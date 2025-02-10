terraform {
  cloud {
    organization = "specialised-tfc"

    workspaces {
      name = "core-infra-develop"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
