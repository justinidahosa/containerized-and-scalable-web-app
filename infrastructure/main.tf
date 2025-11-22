module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  azs                 = var.azs
  public_subnets      = var.public_subnets
  private_app_subnets = var.private_app_subnets
  private_db_subnets  = var.private_db_subnets
}

module "acm" {
  source         = "./modules/acm"
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
}


module "ecr" {
  source = "./modules/ecr"
  name   = var.container_repo_name
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  container_port      = var.container_port
  acm_certificate_arn = module.acm.validated_certificate_arn
}

module "ecs" {
  source                          = "./modules/ecs"
  cluster_name                    = "web-cluster"
  vpc_id                          = module.network.vpc_id
  private_subnet_ids              = module.network.private_app_subnet_ids
  ecs_service_sg_ingress_from_alb = module.alb.security_group_id
  container_port                  = var.container_port
  desired_count                   = var.desired_count
  image                           = "${module.ecr.repo_url}:${var.image_tag}"
  target_group_arn                = module.alb.target_group_arn
  dynamodb_table_name             = module.dynamodb_app.table_name
}

module "dynamodb_app" {
  source   = "./modules/dynamodb_app"
  name     = "app-items"
  hash_key = "pk"
}

module "cognito" {
  source        = "./modules/cognito"
  region        = var.region
  domain_prefix = var.cognito_domain_prefix
  callback_urls = ["https://${var.domain_name}/oauth2/idpresponse"]
  logout_urls   = ["https://${var.domain_name}/logout"]
}

module "apigw" {
  source             = "./modules/apigw"
  api_name           = "edge-api"
  stage_name         = var.stage_name
  audience_client_id = module.cognito.app_client_id
  cognito_issuer     = module.cognito.jwt_issuer
  alb_custom_host    = "api.${var.domain_name}"
}

module "s3_static" {
  source                = "./modules/s3_static"
  s3_static_bucket_name = var.s3_static_bucket_name
}

module "cloudfront" {
  source                = "./modules/cloudfront"
  domain_name           = var.domain_name
  certificate_arn       = module.acm.validated_certificate_arn
  s3_bucket_name        = module.s3_static.bucket_name
  s3_bucket_arn         = module.s3_static.bucket_arn
  s3_bucket_domain_name = module.s3_static.bucket_regional_domain_name
  api_domain_name       = module.apigw.api_execute_url
  api_origin_path       = var.api_origin_path
}

module "route53" {
  source                    = "./modules/route53"
  hosted_zone_id            = var.hosted_zone_id
  domain_name               = var.domain_name
  cloudfront_domain_name    = module.cloudfront.domain_name
  cloudfront_hosted_zone_id = module.cloudfront.hosted_zone_id
  alb_dns_name              = module.alb.alb_dns_name
  alb_hosted_zone_id        = module.alb.alb_hosted_zone_id
}

module "cloudwatch" {
  source           = "./modules/cloudwatch"
  sns_email        = var.sns_alarm_email
  ecs_cluster_name = "web-cluster"
  ecs_service_name = module.ecs.service_name
  alb_arn_suffix   = module.alb.alb_arn_suffix
  api_id           = module.apigw.api_id
}

module "iam_github" {
  source              = "./modules/iam_github_oidc"
  github_org          = var.github_org
  github_repo         = var.github_repo
  provider_thumbprint = var.github_oidc_thumbprint

  # Backend access for Terraform state
  state_bucket_name   = var.state_bucket_name
  state_bucket_prefix = var.state_bucket_prefix
  lock_table_arn      = var.lock_table_arn
  # Deploy scope (from modules in this same apply)
  ecr_repo_arn       = module.ecr.repo_arn
  ecs_service_arn    = module.ecs.service_arn
  task_role_arn      = module.ecs.task_role_arn
  execution_role_arn = module.ecs.exec_role_arn
}

