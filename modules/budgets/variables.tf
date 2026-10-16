variable "name_prefix" {
  description = "Prefix for the budget name, e.g. budgettracker-dev."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,64}$", var.name_prefix))
    error_message = "name_prefix must be 1-64 chars of letters, digits and hyphens."
  }
}

variable "alert_email" {
  description = "Email address that receives budget alerts. No confirmation step, unlike SNS."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email must be a valid email address."
  }
}

# Amounts are strings: the Budgets API takes decimal strings, and floats are
# the wrong type for money.
variable "monthly_limit_usd" {
  description = "Monthly budget limit in USD. Must be above zero; 1.00 matches the AWS zero-spend template."
  type        = string
  default     = "1.00"

  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]{1,2})?$", var.monthly_limit_usd)) && tonumber(var.monthly_limit_usd) > 0
    error_message = "monthly_limit_usd must be a positive amount like \"1.00\"."
  }
}

variable "first_spend_alert_usd" {
  description = "Absolute actual spend, in USD, that triggers the 'any spend' alert."
  type        = string
  default     = "0.01"

  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]{1,2})?$", var.first_spend_alert_usd))
    error_message = "first_spend_alert_usd must be an amount like \"0.01\"."
  }
}

variable "include_credits" {
  description = "Count AWS credits against spend. False shows real usage even when credits would hide it."
  type        = bool
  default     = false
}
