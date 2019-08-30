resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = "${var.max_capacity}"
  min_capacity       = "${var.min_capacity}"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.webapp.name}"
  role_arn           = "${aws_iam_role.ecs_task_execution_role.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_cloudwatch_metric_alarm" "ecs_service_scale_up_alarm" {
  alarm_name          = "${terraform.env}-${aws_ecs_cluster.main.name}-${aws_ecs_service.webapp.name}-ECSServiceScaleUpAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.period_down}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold_up}"
  datapoints_to_alarm = "${var.datapoints_to_alarm_up}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.webapp.name}"
  }

  alarm_description = "This metric monitor ecs CPU utilization up"
  alarm_actions     = ["${aws_appautoscaling_policy.scale_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_service_scale_down_alarm" {
  alarm_name          = "${terraform.env}-${aws_ecs_cluster.main.name}-${aws_ecs_service.webapp.name}-ECSServiceScaleDownAlarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.period_down}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold_down}"
  datapoints_to_alarm = "${var.datapoints_to_alarm_down}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.webapp.name}"
  }

  alarm_description = "This metric monitor ecs CPU utilization down"
  alarm_actions     = ["${aws_appautoscaling_policy.scale_down.arn}"]
}

resource "aws_appautoscaling_policy" "scale_down" {
  name               = "${terraform.env}-${aws_ecs_cluster.main.name}-${aws_ecs_service.webapp.name}-scale-down"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.webapp.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = "${var.upperbound}"
      scaling_adjustment          = "${var.scale_down_adjustment}"
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${terraform.env}-${aws_ecs_cluster.main.name}-${aws_ecs_service.webapp.name}-scale-up"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.webapp.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = "${var.lowerbound}"
      scaling_adjustment          = "${var.scale_up_adjustment}"
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}
