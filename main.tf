terraform {
  required_version = ">= 1.11.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  backend "s3" {
    bucket       = "lambda-monitoring-terraform-state"
    use_lockfile = true
    key          = "base/terraform.tfstate"
    region       = "ap-southeast-2"
    profile      = "kism"
  }
}

provider "aws" {
  profile             = "kism"
  region              = var.region
  allowed_account_ids = [var.kism_account_id]
  default_tags {
    tags = local.tags
  }
}

locals {
  tags = {
    created-by = "tf-lambda-monitoring"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
