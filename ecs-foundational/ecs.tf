resource "aws_ecs_cluster" "default" {
  name = "${var.app_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}