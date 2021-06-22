data "aws_region" "current" {}

locals {
  bucket_name = "terraform-state-${random_id.suffix.hex}"
  table_name  = "terraform-state-${random_id.suffix.hex}-lock"
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = local.table_name
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "local_file" "terraform_backend" {
  content = templatefile("${path.module}/templates/terraform.tf.tpl",
    {
      "bucket_name" = local.bucket_name
      "region"      = data.aws_region.current.name
      "table_name"  = local.table_name
    }
  )
  filename        = var.output_file
  file_permission = "0644"
}
