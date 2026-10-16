data "aws_caller_identity" "current" {}

# Read-only lookups of the SST-managed functions. Terraform never owns these;
# a wrong name fails the plan instead of silently alarming on nothing.
data "aws_lambda_function" "this" {
  for_each = var.functions

  function_name = each.value
}

resource "aws_sns_topic" "alerts" {
  #checkov:skip=CKV_AWS_26:CloudWatch cannot publish to a topic encrypted with the AWS-managed SNS key, and a customer-managed KMS key costs 1 USD/month. Alarm payloads hold no sensitive data.
  name = "${var.name_prefix}-alerts"
}

data "aws_iam_policy_document" "alerts" {
  statement {
    sid     = "AllowCloudWatchAlarmsFromThisAccount"
    effect  = "Allow"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }

    resources = [aws_sns_topic.alerts.arn]

    # Confused-deputy guard: only alarms in this account may publish.
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "alerts" {
  arn    = aws_sns_topic.alerts.arn
  policy = data.aws_iam_policy_document.alerts.json
}

# Stays "PendingConfirmation" until the recipient clicks the link AWS emails.
# Terraform cannot confirm email subscriptions on your behalf.
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
