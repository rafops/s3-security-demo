terraform {
  backend "s3" {
    bucket         = "${bucket_name}"
    dynamodb_table = "${table_name}"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "${region}"
  }
}
