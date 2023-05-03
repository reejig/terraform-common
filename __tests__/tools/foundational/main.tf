module "ecs-foundational" {
  source      = "../../../ecs-foundational"
  aws_region  = var.aws_region
  account     = var.account
  environment = var.environment
  app_name    = var.app_name
}