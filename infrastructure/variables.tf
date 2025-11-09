variable "domain_name" {
  type = string
}
variable "hosted_zone_id" {
  type = string
}
variable "cloudfront_zone_id" {
  type    = string
  default = "Z2FDTNDATAQYW2"
}

variable "azs" {
  type = list(string)
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_app_subnets" {
  type = list(string)
}
variable "private_db_subnets" {
  type = list(string)
}

variable "container_repo_name" {
  type = string
}
variable "container_port" {
  type    = number
  default = 3000
}
variable "desired_count" {
  type    = number
  default = 2
}

variable "github_org" {
  type = string
}
variable "github_repo" {
  type = string
}
variable "github_oidc_thumbprint" {
  type    = string
  default = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "api_stage_name" {
  type    = string
  default = "prod"
}
variable "cognito_domain_prefix" {
  type = string
}
variable "sns_alarm_email" {
  type    = string
  default = ""
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "s3_static_bucket_name" {
  type = string
}
variable "state_bucket_name" {
  type = string
}
variable "state_bucket_prefix" {
  type = string
}
variable "lock_table_arn" {
  type = string
}
variable "stage_name" { type = string }
variable "api_origin_path" { type = string }

variable "region" {
  type    = string
  default = "us-east-1"
}


