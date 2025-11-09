output "distribution_id" { value = aws_cloudfront_distribution.dist.id }
output "distribution_arn" { value = aws_cloudfront_distribution.dist.arn }
output "domain_name" { value = aws_cloudfront_distribution.dist.domain_name }
output "hosted_zone_id" { value = aws_cloudfront_distribution.dist.hosted_zone_id }