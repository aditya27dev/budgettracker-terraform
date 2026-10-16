locals {
  # Each entry becomes one notification. AWS allows up to 5 per budget.
  notifications = [
    {
      # Any real charge at all: mirrors the console's zero-spend template.
      type           = "ACTUAL"
      operator       = "GREATER_THAN"
      threshold      = tonumber(var.first_spend_alert_usd)
      threshold_type = "ABSOLUTE_VALUE"
    },
    {
      # The limit has been reached.
      type           = "ACTUAL"
      operator       = "GREATER_THAN"
      threshold      = 100
      threshold_type = "PERCENTAGE"
    },
    {
      # On track to exceed the limit before month end. Needs some billing
      # history before AWS produces a forecast.
      type           = "FORECASTED"
      operator       = "GREATER_THAN"
      threshold      = 100
      threshold_type = "PERCENTAGE"
    },
  ]
}

resource "aws_budgets_budget" "monthly" {
  name         = "${var.name_prefix}-zero-spend"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = var.monthly_limit_usd
  limit_unit   = "USD"

  cost_types {
    # Credits and refunds can mask real usage, so they are excluded by
    # default: the question this budget answers is "am I really at $0?".
    include_credit = var.include_credits
    include_refund = false
  }

  dynamic "notification" {
    for_each = local.notifications

    content {
      notification_type          = notification.value.type
      comparison_operator        = notification.value.operator
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
      subscriber_email_addresses = [var.alert_email]
    }
  }
}
