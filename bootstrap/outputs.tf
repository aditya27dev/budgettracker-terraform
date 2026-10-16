output "state_bucket_name" {
  description = "Name of the remote state bucket. Use it as `bucket` in environments/*/backend config."
  value       = aws_s3_bucket.state.bucket
}

output "region" {
  description = "Region the state bucket lives in."
  value       = var.region
}
