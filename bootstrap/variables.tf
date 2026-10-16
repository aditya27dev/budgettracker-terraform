variable "region" {
  description = "AWS region for the state bucket. Keep it in the same region as the infrastructure it describes."
  type        = string
  default     = "eu-west-1"
}

variable "bucket_prefix" {
  description = "Prefix for the state bucket name. A random suffix is appended for global uniqueness."
  type        = string
  default     = "budgettracker-tfstate"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{2,45}$", var.bucket_prefix))
    error_message = "bucket_prefix must be 3-46 chars of lowercase letters, digits and hyphens (S3 naming rules, leaving room for the suffix)."
  }
}

variable "noncurrent_version_retention_days" {
  description = "Days to keep previous state versions before S3 deletes them."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_retention_days >= 1
    error_message = "Retention must be at least 1 day."
  }
}
