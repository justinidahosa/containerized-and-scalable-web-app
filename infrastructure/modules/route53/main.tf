# Apex → CloudFront
resource "aws_route53_record" "apex_cf" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name # justindemo.click
  type    = "A"
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# app.justindemo.click → CloudFront
resource "aws_route53_record" "app_cf" {
  zone_id = var.hosted_zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# api.justindemo.click → ALB
resource "aws_route53_record" "api_alb" {
  zone_id = var.hosted_zone_id
  name    = "api.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_hosted_zone_id
    evaluate_target_health = true
  }
}
