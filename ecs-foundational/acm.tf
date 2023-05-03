module "public_acm_cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = "${local.domain_name}.${data.terraform_remote_state.dns.outputs.public_domain_name}"
  zone_id     = data.terraform_remote_state.dns.outputs.public_zone_id

  wait_for_validation = true

  tags = merge(local.tags, { Name = "${var.app_name}-${local.region_short_name}-public-cluster-cert" })
}