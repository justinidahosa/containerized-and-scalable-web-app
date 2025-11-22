output "cloudfront_domain" {
  value = module.cloudfront.domain_name
}
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
output "api_execute_url" {
  value = module.apigw.api_execute_url
}
output "ecr_repo_url" {
  value = module.ecr.repo_url
}
output "iam_ci_role_arn" {
  value = module.iam_github.iam_ci_role_arn
}
output "s3_static_bucket_name" {
  value = module.s3_static.bucket_name
}
output "s3_static_bucket_arn" {
  value = module.s3_static.bucket_arn
}
output "s3_static_bucket_domain_name" {
  value = module.s3_static.bucket_regional_domain_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}
output "cloudfront_distribution_arn" {
  value = module.cloudfront.distribution_arn
}
output "alb_target_group_arn" {
  value = module.alb.target_group_arn
}



