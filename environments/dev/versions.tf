terraform {
  # 1.11 is the first release with GA S3 native state locking.
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Root modules pin the range: any 6.x from 6.69 up, never an unreviewed 7.0.
      # The exact build is fixed by .terraform.lock.hcl and bumped via Dependabot PRs.
      version = "~> 6.69"
    }
  }

  # Partial configuration: the bucket name comes from backend.hcl locally
  # (git-ignored) or from a GitHub variable in CI, via -backend-config.
  backend "s3" {
    key          = "dev/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true # S3 native lock (<key>.tflock), no DynamoDB table
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "budgettracker-infra"
      ManagedBy   = "terraform"
      Environment = "dev"
    }
  }
}
