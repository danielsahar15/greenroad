resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/containerinsights/${var.cluster_name}/application"
  retention_in_days = 30
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.cluster_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_threshold
  alarm_description   = "This metric monitors EKS node CPU utilization"
  dimensions = {
    AutoScalingGroupName = var.node_group_name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.cluster_name}-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_threshold
  alarm_description   = "This metric monitors EKS node memory utilization"
  dimensions = {
    AutoScalingGroupName = var.node_group_name
  }
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name          = "${var.cluster_name}-app-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_threshold
  alarm_description   = "This metric monitors road-safety app pod CPU utilization"
  dimensions = {
    ClusterName = var.cluster_name
    Namespace   = "default"
    PodName     = "road-safety-.*"
  }
}

resource "aws_cloudwatch_metric_alarm" "app_memory_high" {
  alarm_name          = "${var.cluster_name}-app-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_threshold
  alarm_description   = "This metric monitors road-safety app pod memory utilization"
  dimensions = {
    ClusterName = var.cluster_name
    Namespace   = "default"
    PodName     = "road-safety-.*"
  }
}

resource "aws_cloudwatch_dashboard" "eks_dashboard" {
  dashboard_name = "${var.cluster_name}-Monitoring"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.node_group_name],
            [".", "MemoryUtilization", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          title   = "EKS Node CPU & Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_cpu_utilization", "ClusterName", var.cluster_name, "Namespace", "default", "PodName", "road-safety-.*"],
            [".", "pod_memory_utilization", ".", ".", ".", ".", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          title   = "Road-Safety App Pod CPU & Memory Utilization"
        }
      }
    ]
  })
}