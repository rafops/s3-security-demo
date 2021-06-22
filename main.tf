locals {
  bucket_name = "s3-security-demo-${random_id.suffix.hex}"
  bucket_arn  = "arn:aws:s3:::${local.bucket_name}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

data "aws_canonical_user_id" "current" {}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.5.0"

  bucket = local.bucket_name

  acl = null
  grant = [
    {
      type        = "Group"
      permissions = ["READ"]
      uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
    },
    {
      type        = "CanonicalUser"
      permissions = ["FULL_CONTROL"]
      id          = data.aws_canonical_user_id.current.id
    }
  ]

  versioning = {
    enabled = true
  }

  force_destroy                         = true
  attach_deny_insecure_transport_policy = true
}
