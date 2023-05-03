resource "aws_cloudwatch_log_group" "default" {
  name              = "${local.region_short_name}/svc-${var.app_name}"
  retention_in_days = 365
  tags              = merge(local.tags, { Name = "${local.region_short_name}/svc-${var.app_name}" })
}
