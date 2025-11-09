variable "domain_name" { type = string }     # justindemo.click
variable "certificate_arn" { type = string } # from acm
variable "s3_bucket_name" { type = string }
variable "s3_bucket_arn" { type = string }
variable "s3_bucket_domain_name" { type = string }
variable "api_domain_name" { type = string }       
variable "api_origin_path" { type = string }    
