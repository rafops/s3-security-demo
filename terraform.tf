terraform {
  backend "s3" {
    bucket         = "terraform-state-0bc946b41e017287"
    dynamodb_table = "terraform-state-0bc946b41e017287-lock"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
