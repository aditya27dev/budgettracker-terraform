output "alerts_topic_arn" {
  description = "SNS topic that receives alarm notifications."
  value       = module.monitoring.sns_topic_arn
}

output "alarm_names" {
  description = "CloudWatch alarm names per function key."
  value       = module.monitoring.alarm_names
}

output "duration_thresholds_ms" {
  description = "Derived p95 duration threshold per function key."
  value       = module.monitoring.duration_thresholds_ms
}

output "budget_name" {
  description = "Monthly zero-spend budget name."
  value       = module.budgets.budget_name
}
