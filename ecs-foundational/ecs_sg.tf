
module "ecs_instance_app_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.4"

  use_name_prefix = false
  name            = "${var.app_name}-${local.region_short_name}-application-sg"

  description = "Security group for ${var.app_name}-${local.region_short_name} application"
  vpc_id      = data.terraform_remote_state.environment.outputs.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.ecs_instance_alb_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = merge(local.tags, { Name = "${var.app_name}-${local.region_short_name}-application-sg" })
}