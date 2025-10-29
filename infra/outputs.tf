output "cloudfront_domain" { 
    value = module.cloudfront.domain_name 
}
output "app_url"           { 
    value = "https://${var.subdomain_app}.${var.domain_name}" 
}
output "api_url"           { 
    value = "https://${var.subdomain_api}.${var.domain_name}" 
}
output "ecr_repo"          { 
    value = module.ecr.repository_url 
}
output "gha_role_arn"      { 
    value = module.ci_oidc.gha_role_arn 
}