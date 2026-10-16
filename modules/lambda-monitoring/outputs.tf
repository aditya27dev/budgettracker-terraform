output "sns_topic_arn" {
  description = "ARN of the alerts topic."
  value       = aws_sns_topic.alerts.arn
}

output "alarm_names" {
  description = "Alarm names per function key."
  value = {
    for k in keys(var.functions) : k => [
      aws_cloudwatch_metric_alarm.errors[k].alarm_name,
      aws_cloudwatch_metric_alarm.throttles[k].alarm_name,
      aws_cloudwatch_metric_alarm.duration_p95[k].alarm_name,
    ]
  }
}

output "duration_thresholds_ms" {
  description = "Derived p95 duration threshold per function key, in milliseconds."
  value       = local.duration_threshold_ms
}
