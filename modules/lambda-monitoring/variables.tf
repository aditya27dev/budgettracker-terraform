variable "name_prefix" {
  description = "Prefix for the SNS topic and alarm names, e.g. budgettracker-dev."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,64}$", var.name_prefix))
    error_message = "name_prefix must be 1-64 chars of letters, digits and hyphens."
  }
}

variable "functions" {
  description = <<-EOT
    Map of stable short key => existing Lambda function name. Keys are used in
    alarm names and resource addresses, so they must not change; values can
    change (e.g. SST recreates a function with a new suffix) without
    destroying the alarms.
  EOT
  type        = map(string)

  validation {
    condition     = length(var.functions) > 0
    error_message = "Provide at least one function to monitor."
  }

  validation {
    condition     = alltrue([for k in keys(var.functions) : can(regex("^[a-z0-9-]{1,32}$", k))])
    error_message = "Function keys must be 1-32 chars of lowercase letters, digits and hyphens."
  }
}

variable "alert_email" {
  description = "Email address subscribed to the alerts topic. Needs a one-off confirmation click."
  type        = string
  # Hides the address in plan/apply output, which is public in CI logs for a public repo.
  sensitive = true

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email must be a valid email address."
  }
}

variable "period_seconds" {
  description = "Aggregation period for every alarm, in seconds."
  type        = number
  default     = 300

  validation {
    condition     = var.period_seconds >= 60 && var.period_seconds % 60 == 0
    error_message = "period_seconds must be a multiple of 60 (standard resolution keeps alarms in the free tier)."
  }
}

variable "error_threshold" {
  description = "Alarm when the Errors sum in one period reaches this value."
  type        = number
  default     = 1
}

variable "throttle_threshold" {
  description = "Alarm when the Throttles sum in one period reaches this value."
  type        = number
  default     = 1
}

variable "duration_threshold_percent" {
  description = "Alarm when p95 Duration exceeds this percentage of the function's configured timeout."
  type        = number
  default     = 80

  validation {
    condition     = var.duration_threshold_percent > 0 && var.duration_threshold_percent <= 100
    error_message = "duration_threshold_percent must be between 1 and 100."
  }
}
