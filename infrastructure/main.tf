
module "network" {
  source          = "./modules/network"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}


module "acm" {
  source         = "./modules/acm"
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
}


module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  target_port       = var.container_port
  certificate_arn   = module.acm.certificate_arn
}


module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}


module "dynamodb" {
  source       = "./modules/dynamodb"
  project_name = var.project_name
  table_name   = var.dynamodb_table_name
}


module "ecs" {
  source                 = "./modules/ecs"
  project_name           = var.project_name
  vpc_id                 = module.network.vpc_id
  private_subnet_ids     = module.network.private_subnet_ids
  alb_security_group_id  = module.alb.alb_security_group_id
  target_group_arn       = module.alb.target_group_arn
  alb_https_listener_arn = module.alb.https_listener_arn
  ecr_repository_url     = module.ecr.repository_url
  image_tag              = var.image_tag
  container_port         = var.container_port
  container_cpu          = var.container_cpu
  container_memory       = var.container_memory
  desired_count          = var.desired_count
  dynamodb_table_name    = module.dynamodb.table_name
}


module "s3_frontend" {
  source       = "./modules/s3_frontend"
  project_name = var.project_name
}


module "cloudfront_frontend" {
  source                = "./modules/cloudfront_frontend"
  project_name          = var.project_name
  s3_bucket_domain_name = module.s3_frontend.bucket_domain_name
  certificate_arn       = module.acm.certificate_arn
  oai_path              = module.s3_frontend.oai_path
}


module "cognito" {
  source        = "./modules/cognito"
  project_name  = var.project_name
  callback_urls = [
    "https://${var.subdomain_app}.${var.domain_name}/callback",
    "http://localhost:3000/callback"
  ]
  logout_urls = [
    "https://${var.subdomain_app}.${var.domain_name}/logout",
    "http://localhost:3000/logout"
  ]
}


module "apigw" {
  source          = "./modules/apigw"
  project_name    = var.project_name
  region          = var.region
  domain_name     = var.domain_name
  subdomain_api   = var.subdomain_api
  certificate_arn = module.acm.certificate_arn
  alb_dns_name    = module.alb.alb_dns_name
  jwt_audience    = [module.cognito.user_pool_client_id]
  user_pool_id    = module.cognito.user_pool_id
}


module "route53" {
  source                     = "./modules/route53"
  hosted_zone_id             = var.hosted_zone_id
  domain_name                = var.domain_name
  subdomain_app              = var.subdomain_app
  subdomain_api              = var.subdomain_api
  cloudfront_domain_name     = module.cloudfront_frontend.cloudfront_domain_name
  cloudfront_hosted_zone_id  = module.cloudfront_frontend.cloudfront_hosted_zone_id
  api_gw_domain_name         = module.apigw.api_domain_name
  api_gw_hosted_zone_id      = module.apigw.api_hosted_zone_id
  alb_dns_name               = module.alb.alb_dns_name
  alb_zone_id                = module.alb.alb_zone_id
}

module "monitoring" {
  source         = "./modules/monitoring"
  project_name   = var.project_name
  region         = var.region
  alb_full_name  = module.alb.alb_arn 
  cluster_name   = module.ecs.cluster_name
  service_name   = module.ecs.service_name
  ddb_table_name = module.dynamodb.table_name
}

module "ci_oidc" {
  source       = "./modules/ci_oidc"
  project_name = var.project_name
  github_org   = var.github_org
  github_repo  = var.github_repo
}
