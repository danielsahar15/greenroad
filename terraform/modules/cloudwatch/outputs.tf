output "dashboard_name" {
  value = aws_cloudwatch_dashboard.eks_dashboard.dashboard_name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.application_logs.name
}

output "cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}

output "memory_alarm_name" {
  value = aws_cloudwatch_metric_alarm.memory_high.alarm_name
}

output "app_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.app_cpu_high.alarm_name
}

output "app_memory_alarm_name" {
  value = aws_cloudwatch_metric_alarm.app_memory_high.alarm_name
}