variable "environment_name" {
  description = "The environment name used for tagging and resource naming. Default value is set using TF_VAR_environment_name variable inside runtime container based on current directory."
  default = "default"
}

variable "environment_owner" {
  description = "The environment owner used for tagging. Default value is set using TF_VAR_environment_owner variable inside runtime container based on host user."
  default = "default"
}

variable "aws_region" {
  description = "The AWS region used by Terraform AWS provider."
  default = "us-east-1"
}

variable "pgp_key" {
  description = "The PGP key used for encrypting secrets (optional)."
  default = ""
}
