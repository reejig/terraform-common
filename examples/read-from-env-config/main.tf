variable "region" {
  description = "Region for the configuration"
  type        = string
  default     = "eu-west-2"
}

variable "config_branch" {
  description = "Branch for the configuration"
  type        = string
  default     = "refs/heads/main"
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "environments_definition"
}

locals {
  environment = "prod"
}

data "aws_s3_object" "environments_definition" {
  provider = aws.environments_definition
  bucket   = "reejig-app-configuration-${local.environment}"
  key      = "environments-sites-customers${var.config_branch == "refs/heads/main" ? "/" : "/${var.config_branch}/"}environments_definition.json"
}

output "siteIds" {
  value = [ for site in jsondecode(data.aws_s3_object.environments_definition.body)[local.environment]["regions"][var.region]["sites"] : site.siteId ]
}

output "customers" {
  value = flatten([
    for site in jsondecode(data.aws_s3_object.environments_definition.body)[local.environment]["regions"][var.region]["sites"] : [
      for customer in site.customers : customer.name
    ]
  ])
}