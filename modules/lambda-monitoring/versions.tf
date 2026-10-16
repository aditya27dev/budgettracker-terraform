terraform {
  required_version = ">= 1.11"

  # Modules declare a minimum only; the root module (environments/*) pins the
  # exact range so every module in an environment shares one provider build.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
