resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_name}-alb-5xx"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 5
  threshold           = 5
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    LoadBalancer = var.alb_full_name
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name          = "${var.project_name}-ecs-high-cpu"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }
}

resource "aws_cloudwatch_metric_alarm" "ddb_throttle" {
  alarm_name          = "${var.project_name}-ddb-throttle"
  metric_name         = "ThrottledRequests"
  namespace           = "AWS/DynamoDB"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    TableName = var.ddb_table_name
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x=0, y=0, width=12, height=6,
        properties = {
          view="timeSeries", region=var.region, title="ALB 5xx",
          metrics = [["AWS/ApplicationELB","HTTPCode_ELB_5XX_Count","LoadBalancer",var.alb_full_name]]
        }
      },
      {
        type="metric",
        x=12,y=0,width=12,height=6,
        properties={
          view="timeSeries",region=var.region,title="ECS CPU%",
          metrics=[["AWS/ECS","CPUUtilization","ClusterName",var.cluster_name,"ServiceName",var.service_name]]
        }
      },
      {
        type="metric",
        x=0,y=6,width=12,height=6,
        properties={
          view="timeSeries",region=var.region,title="DynamoDB Throttles",
          metrics=[["AWS/DynamoDB","ThrottledRequests","TableName",var.ddb_table_name]]
        }
      }
    ]
  })
}