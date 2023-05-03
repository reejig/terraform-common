data "aws_caller_identity" "this" {}

#-----------------------------------------------------------------------------------------------------------------------
# Account level workspaces
#-----------------------------------------------------------------------------------------------------------------------
data "terraform_remote_state" "environment" {
  backend = "s3"

  workspace = "${var.account}-${var.aws_region}"

  config = {
    region               = "ap-southeast-2"
    bucket               = "${var.account}-terraform-remote-state"
    key                  = "global/environment/terraform.tfstate"
    workspace_key_prefix = "account"
  }
}

#-----------------------------------------------------------------------------------------------------------------------
# Account level workspaces
#-----------------------------------------------------------------------------------------------------------------------
data "terraform_remote_state" "dns" {
  backend = "s3"

  workspace =  var.account

  config = {
    region               = "ap-southeast-2"
    bucket               = "${var.account}-terraform-remote-state"
    key                  = "global/dns/terraform.tfstate"
    workspace_key_prefix = "account"
  }
}
