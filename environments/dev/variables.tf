variable "region" {
  description = "AWS region of the SST dev stage."
  type        = string
  default     = "eu-west-1"
}

variable "name_prefix" {
  description = "Prefix for every resource this environment creates."
  type        = string
  default     = "budgettracker-dev"
}

variable "lambda_functions" {
  description = "Stable short key => SST-generated Lambda function name to monitor."
  type        = map(string)
}

variable "alert_email" {
  description = "Email address for alarm and budget alerts."
  type        = string
  sensitive   = true
}

variable "duration_threshold_percent" {
  description = "p95 duration alarm threshold as a percentage of each function's timeout."
  type        = number
  default     = 80
}

variable "monthly_budget_usd" {
  description = "Monthly budget limit in USD."
  type        = string
  default     = "1.00"
}
