/*
 * Create autoscaling policies
 */
resource "aws_autoscaling_policy" "up" {
  name                   = "${var.cluster_name}-scaleUp"
  scaling_adjustment     = var.scaling_adjustment_up
  adjustment_type        = var.adjustment_type
  cooldown               = var.policy_cooldown
  policy_type            = "SimpleScaling"
  autoscaling_group_name = var.aws_autoscaling_group
  count                  = var.alarm_actions_enabled ? 1 : 0
}

resource "aws_autoscaling_policy" "down" {
  name                   = "${var.cluster_name}-scaleDown"
  scaling_adjustment     = var.scaling_adjustment_down
  adjustment_type        = var.adjustment_type
  cooldown               = var.policy_cooldown
  policy_type            = "SimpleScaling"
  autoscaling_group_name = var.aws_autoscaling_group
  count                  = var.alarm_actions_enabled ? 1 : 0
}

/*
 * Create CloudWatch alarms to trigger scaling of ASG
 */
resource "aws_cloudwatch_metric_alarm" "scaleUp" {
  alarm_name          = "${var.cluster_name}-scaleUp"
  alarm_description   = "ECS cluster scaling metric above threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.scaling_metric_name
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = var.alarm_period
  threshold           = var.alarm_threshold_up
  actions_enabled     = var.alarm_actions_enabled
  count               = var.alarm_actions_enabled ? 1 : 0
  alarm_actions       = [aws_autoscaling_policy.up[0].arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "scaleDown" {
  alarm_name          = "${var.cluster_name}-scaleDown"
  alarm_description   = "ECS cluster scaling metric under threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.scaling_metric_name
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = var.alarm_period
  threshold           = var.alarm_threshold_down
  actions_enabled     = var.alarm_actions_enabled
  count               = var.alarm_actions_enabled ? 1 : 0
  alarm_actions       = [aws_autoscaling_policy.down[0].arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}
