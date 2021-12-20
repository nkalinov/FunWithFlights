provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

terraform {
  required_version = ">= 0.14.9"

  cloud {
    organization = "funwithflights"

    workspaces {
      name = "main"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

data "aws_region" "current" {}

output "aws_region" {
  value = data.aws_region.current.name
}
