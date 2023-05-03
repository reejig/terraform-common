resource "aws_route53_record" "api" {
  zone_id = data.terraform_remote_state.dns.outputs.public_zone_id

  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = false
  }
}

resource "aws_ssm_parameter" "service_url" {
  name        = "/reejig-app/svc-${var.app_name}/url"
  type        = "String"

  value = "https://${aws_route53_record.api.fqdn}"

  tags = local.tags
}