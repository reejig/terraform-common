module "ecs_instance_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.4"

  use_name_prefix = false
  name            = "${var.app_name}-${local.region_short_name}-public-lb"

  description = "Security group for ${var.app_name}-${local.region_short_name} public load balancer."
  vpc_id      = data.terraform_remote_state.environment.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = merge(local.tags, { Name = "${var.app_name}-${local.region_short_name}-public-lb-sg" })
}