output "terraform_state_bucket" {
  value       = aws_s3_bucket.terraform_state.id
  description = "The S3 bucket where Terraform state is stored."
}

output "terraform_state_lock_table" {
  value       = aws_dynamodb_table.terraform_state_lock.id
  description = "The DynamoDB table used for Terraform state locking."
}
