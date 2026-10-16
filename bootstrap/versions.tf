terraform {
  # 1.11 is the first release where S3 native state locking (use_lockfile) is GA.
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # No backend block on purpose: this root creates the state bucket, so its
  # own state stays local (see README, "Bootstrap").
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "budgettracker-infra"
      ManagedBy = "terraform"
      Component = "bootstrap"
    }
  }
}
