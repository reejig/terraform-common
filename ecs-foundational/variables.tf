#-----------------------------------------------------------------------------------------------------------------------
# Common Variables
#-----------------------------------------------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "AWS Region to create resources in"
}

variable "account" {
  type        = string
  description = "Name of the account."
}

variable "environment" {
  type        = string
  description = "Environment resources are being created for"
}

#-----------------------------------------------------------------------------------------------------------------------
# Application Specific Variables
#-----------------------------------------------------------------------------------------------------------------------
variable "app_name" {
  type        = string
  description = "Name of the services being created"
}

#-----------------------------------------------------------------------------------------------------------------------
# locals
#-----------------------------------------------------------------------------------------------------------------------

locals {
  tags = {
    Service     = var.app_name
    Environment = var.environment
    Region      = var.aws_region
    Team        = "application"
    Version     = "1.0.0"
  }

  account_id = data.aws_caller_identity.this.account_id
  region_short_names = {
    "ap-southeast-1" = "sin"
    "ap-southeast-2" = "syd"
    "us-east-1"      = "nva"
    "eu-west-1"      = "irl"
    "eu-west-2"      = "lon"
  }
  region_short_name  = local.region_short_names[var.aws_region]
  domain_name = "${var.app_name}.svc.${local.region_short_name}"
}