variable "hosted_zone_id"           { 
    type = string 
}
variable "domain_name"              { 
    type = string 
}
variable "subdomain_app"            { 
    type = string 
}
variable "subdomain_api"            { 
    type = string 
}
variable "cloudfront_domain_name"   { 
    type = string 
}
variable "cloudfront_hosted_zone_id"{ 
    type = string 
}
variable "api_gw_domain_name"       { 
    type = string 
}
variable "api_gw_hosted_zone_id"    { 
    type = string 
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  type        = string
}