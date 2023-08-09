# ecs module to add autoscaling to services

```
module "ecs-service-autoscaling" {
  source           = "git::git@github.com:reejig/reejig-common.git//ecs-service-autoscaling"
  name_prefix      = "${var.customer}-${var.service}"
  ecs_cluster_name = var.cluster_name
  ecs_service_name = aws_ecs_service.service.name
}
```
