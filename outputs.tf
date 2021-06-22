output "environment_name" {
  value = var.environment_name
}

output "environment_owner" {
  value = var.environment_owner
}

output "aws_region" {
  value = var.aws_region
}

output "s3_bucket_id" {
  value = module.s3_bucket.s3_bucket_id
}
