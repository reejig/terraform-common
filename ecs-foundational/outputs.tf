output "aws_lb_listener_arn" {
    value = aws_lb_listener.public_https.arn
}
output "service_domain" {
  value = aws_route53_record.api.fqdn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.default.repository_url
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.default.arn
}

output "aws_cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.default.name
}

output "ecs_instance_app_sg_id" {
  value = module.ecs_instance_app_sg.security_group_id
}