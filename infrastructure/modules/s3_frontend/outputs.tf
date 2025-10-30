output "bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.frontend.bucket_regional_domain_name
}

output "oai_path" {
  value = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}