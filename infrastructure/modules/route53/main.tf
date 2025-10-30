resource "aws_route53_record" "app_alias" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_app}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api_alias" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_api}.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.api_gw_domain_name
    zone_id                = var.api_gw_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "frontend_alias" {
  zone_id = var.hosted_zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}