module "monitoring" {
  source = "../../modules/lambda-monitoring"

  name_prefix                = var.name_prefix
  functions                  = var.lambda_functions
  alert_email                = var.alert_email
  duration_threshold_percent = var.duration_threshold_percent
}

module "budgets" {
  source = "../../modules/budgets"

  name_prefix       = var.name_prefix
  alert_email       = var.alert_email
  monthly_limit_usd = var.monthly_budget_usd
}
