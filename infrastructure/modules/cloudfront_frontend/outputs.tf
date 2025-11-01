output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend_cf.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.frontend_cf.hosted_zone_id
}

output "oai_path" {
  value = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}

output "cloudfront_oai_id" {
  value = aws_cloudfront_origin_access_identity.oai.id
}

output "cloudfront_oai_iam_arn" {
  value = aws_cloudfront_origin_access_identity.oai.iam_arn
}
