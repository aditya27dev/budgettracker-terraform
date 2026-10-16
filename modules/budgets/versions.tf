terraform {
  required_version = ">= 1.11"

  # Budgets is a global API (served from us-east-1); the provider routes it
  # there regardless of the configured region, so no aliased provider is needed.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
