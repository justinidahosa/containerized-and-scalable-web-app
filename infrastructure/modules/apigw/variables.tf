variable "api_name"           { 
    type = string 
}
variable "stage_name"         { 
    type = string 
}
variable "target_alb_url"     { 
    type = string 
}
variable "cognito_issuer"     { 
    type = string 
}
variable "audience_client_id" { 
    type = string 
}
variable "alb_dns_name" {
  type = string
}