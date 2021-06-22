terraform {
  backend "s3" {
    bucket         = "terraform-state-0a430dd699ec5f0a"
    dynamodb_table = "terraform-state-0a430dd699ec5f0a-lock"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
