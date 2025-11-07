variable "domain_name"           { 
    type = string 
}
variable "certificate_arn"       { 
    type = string 
}
variable "s3_bucket_domain_name" { 
    type = string 
}
variable "s3_bucket_arn"         { 
    type = string 
}
variable "api_domain_name"       { 
    type = string 
} # e.g., abcdef.execute-api.us-east-1.amazonaws.com