resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name          # e.g., justindemo.click
  subject_alternative_names = ["*.${var.domain_name}"] # e.g., *.justindemo.click
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id         = var.hosted_zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.value]
  allow_overwrite = true
}


resource "aws_acm_certificate_validation" "validated" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in values(aws_route53_record.acm_validation) : r.fqdn]
}
