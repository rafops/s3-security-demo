provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment_name
      Owner       = var.environment_owner
    }
  }
}
