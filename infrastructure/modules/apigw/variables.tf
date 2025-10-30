variable "project_name"     { 
    type = string 
}
variable "region"           { 
    type = string 
}
variable "domain_name"      { 
    type = string 
}
variable "subdomain_api"    { 
    type = string 
}
variable "certificate_arn"  { 
    type = string 
}
variable "alb_dns_name"     { 
    type = string 
}
variable "jwt_audience"     { 
    type = list(string) 
}
variable "user_pool_id"     { 
    type = string 
}
