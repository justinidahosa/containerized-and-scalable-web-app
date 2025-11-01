variable "hosted_zone_id" {
  description = "Hosted Zone ID for the domain"
  type        = string
}

variable "domain_name" {
  description = "Root domain name (e.g. justindemo.click)"
  type        = string
}

variable "subdomain_app" {
  description = "Subdomain for the frontend app (e.g. app)"
  type        = string
}

variable "subdomain_api" {
  description = "Subdomain for the backend API (e.g. api)"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "Hosted Zone ID for CloudFront distribution"
  type        = string
}

variable "api_gw_domain_name" {
  description = "Custom domain name for API Gateway"
  type        = string
}

variable "api_gw_hosted_zone_id" {
  description = "Hosted Zone ID for API Gateway custom domain"
  type        = string
}