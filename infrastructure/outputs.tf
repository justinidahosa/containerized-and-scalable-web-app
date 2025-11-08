output "cloudfront_domain" { 
    value = module.cloudfront.cf_domain 
}
output "alb_dns_name"      { 
    value = module.alb.alb_dns_name 
}
output "api_execute_url"   { 
    value = module.apigw.api_url 
}
output "ecr_repo_url"      { 
    value = module.ecr.repo_url 
}
output "iam_ci_role_arn" {
  value = module.iam_github.iam_ci_role_arn
}

