output "cf_domain" { 
    value = aws_cloudfront_distribution.dist.domain_name 
}