output "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  value       = aws_cloudfront_distribution.frontend_cf.hosted_zone_id
}

output "oai_path" {
  description = "Origin Access Identity Path"
  value       = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.frontend_cf.domain_name
}