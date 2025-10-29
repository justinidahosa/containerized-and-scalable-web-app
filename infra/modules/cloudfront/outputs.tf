output "domain_name"       { 
    value = aws_cloudfront_distribution.cloudfront_distro.domain_name 
}
output "hosted_zone_id"    { 
    value = aws_cloudfront_distribution.cloudfront_distro.hosted_zone_id 
}