variable "domain_name" {
  description = "Root domain name (e.g. justindemo.click)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for domain"
  type        = string
}
