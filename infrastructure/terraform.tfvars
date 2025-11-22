domain_name         = "justindemo.click"
hosted_zone_id      = "Z1234567890"
azs                 = ["us-east-1a", "us-east-1b"]
vpc_cidr            = "10.0.0.0/16"
public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
private_app_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
private_db_subnets  = ["10.0.21.0/24", "10.0.22.0/24"]

container_repo_name   = "webapp"
cognito_domain_prefix = "myapp-justin-oct-2025"
github_org            = "justinidahosa"
github_repo           = "containerized-and-scalable-web-app"
sns_alarm_email       = ""

s3_static_bucket_name = "static-bucket-justin-web-app"

state_bucket_name   = "terraform-state-bucket-justin-web-app"
state_bucket_prefix = "backend/terraform.tfstate"
lock_table_arn      = "arn:aws:dynamodb:us-east-1:864899875710:table/tfstate-locks-justin-web-app"

stage_name      = "prod"
api_origin_path = "/prod"