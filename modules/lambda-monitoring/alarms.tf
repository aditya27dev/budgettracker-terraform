# All alarms evaluate a single standard-resolution period (1 of 1). The cron
# functions run once a day, so an M-of-N rule spanning several periods would
# never see enough datapoints to fire. Missing data is "notBreaching" because
# no invocations means no errors, not an outage.

resource "aws_cloudwatch_metric_alarm" "errors" {
  for_each = var.functions

  alarm_name        = "${var.name_prefix}-${each.key}-errors"
  alarm_description = "Lambda ${each.value} returned at least ${var.error_threshold} error(s) in ${var.period_seconds / 60} min."

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  dimensions  = { FunctionName = data.aws_lambda_function.this[each.key].function_name }
  statistic   = "Sum"
  period      = var.period_seconds

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.error_threshold
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "throttles" {
  for_each = var.functions

  alarm_name        = "${var.name_prefix}-${each.key}-throttles"
  alarm_description = "Lambda ${each.value} was throttled at least ${var.throttle_threshold} time(s) in ${var.period_seconds / 60} min."

  namespace   = "AWS/Lambda"
  metric_name = "Throttles"
  dimensions  = { FunctionName = data.aws_lambda_function.this[each.key].function_name }
  statistic   = "Sum"
  period      = var.period_seconds

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = var.throttle_threshold
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

locals {
  # Lambda timeout is in seconds; the Duration metric is in milliseconds.
  duration_threshold_ms = {
    for k, fn in data.aws_lambda_function.this :
    k => fn.timeout * 1000 * var.duration_threshold_percent / 100
  }
}

resource "aws_cloudwatch_metric_alarm" "duration_p95" {
  for_each = var.functions

  alarm_name        = "${var.name_prefix}-${each.key}-duration-p95"
  alarm_description = "Lambda ${each.value} p95 duration exceeded ${var.duration_threshold_percent}% of its timeout (${local.duration_threshold_ms[each.key]} ms) in ${var.period_seconds / 60} min."

  namespace   = "AWS/Lambda"
  metric_name = "Duration"
  dimensions  = { FunctionName = data.aws_lambda_function.this[each.key].function_name }
  # Percentiles need extended_statistic; Average would hide slow tail requests.
  extended_statistic = "p95"
  period             = var.period_seconds

  comparison_operator = "GreaterThanThreshold"
  threshold           = local.duration_threshold_ms[each.key]
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}
