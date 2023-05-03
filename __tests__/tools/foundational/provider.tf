terraform {
  required_version = ">= 1.0.0"
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" { region = var.aws_region }

data "aws_caller_identity" "this" {}