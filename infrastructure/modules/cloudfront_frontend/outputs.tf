
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend_cf.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.frontend_cf.hosted_zone_id
}