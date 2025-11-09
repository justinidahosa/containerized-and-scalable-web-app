variable "domain_name" { type = string }     # justindemo.click
variable "certificate_arn" { type = string } # from acm
variable "s3_bucket_name" { type = string }
variable "s3_bucket_arn" { type = string }
variable "s3_bucket_domain_name" { type = string } # bucket.s3.us-east-1.amazonaws.com
variable "api_domain_name" { type = string }       # e.g., abcd.execute-api.us-east-1.amazonaws.com
variable "api_origin_path" { type = string }       # "" or "/prod"
