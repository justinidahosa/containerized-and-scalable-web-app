resource "aws_sns_topic" "alerts" {
  count = length(var.sns_email) > 0 ? 1 : 0
  name  = "app-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  count     = length(var.sns_email) > 0 ? 1 : 0
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.sns_email
}
locals { topic_arn = length(var.sns_email) > 0 ? aws_sns_topic.alerts[0].arn : null }

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "app-observability"
  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 0, "y" : 0, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "ECS CPU",
          "region" : "us-east-1",
          "view" : "timeSeries",
          "stat" : "Average",
          "period" : 60,
          "metrics" : [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ],
          "yAxis" : { "left" : { "min" : 0, "max" : 100 } }
        }
      },
      {
        "type" : "metric",
        "x" : 0, "y" : 6, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "ALB 5XX",
          "region" : "us-east-1",
          "view" : "timeSeries",
          "stat" : "Sum",
          "period" : 60,
          "metrics" : [
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix]
          ]
        }
      },
      {
        "type" : "metric",
        "x" : 0, "y" : 12, "width" : 12, "height" : 6,
        "properties" : {
          "title" : "API 5XX",
          "region" : "us-east-1",
          "view" : "timeSeries",
          "stat" : "Sum",
          "period" : 60,
          "metrics" : [
            ["AWS/ApiGateway", "5XXError", "ApiId", var.api_id]
          ]
        }
      }
    ]
  })
}



resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "ECS-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  dimensions          = { ClusterName = var.ecs_cluster_name, ServiceName = var.ecs_service_name }
  alarm_actions       = local.topic_arn == null ? [] : [local.topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "ALB-5XX-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  dimensions          = { LoadBalancer = var.alb_arn_suffix }
  alarm_actions       = local.topic_arn == null ? [] : [local.topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "api_5xx" {
  alarm_name          = "APIGW-5XX-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  dimensions          = { ApiId = var.api_id }
  alarm_actions       = local.topic_arn == null ? [] : [local.topic_arn]
}
