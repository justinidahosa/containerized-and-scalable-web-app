output "cf_domain" { 
    value = aws_cloudfront_distribution.dist.domain_name 
}
output "distribution_id" {
  value = aws_cloudfront_distribution.dist.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.dist.arn
}
