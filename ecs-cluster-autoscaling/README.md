# ecs module to add autoscaling to cluster

```
module "ecs-cluster-autoscaling" {
  source                = "git::git@github.com:reejig/reejig-common.git//ecs-cluster-autoscaling"
  cluster_name          = var.cluster_name
  aws_autoscaling_group = aws_autoscaling_group.group.name
}
```
