region              = "us-east-1"
project_name        = "app"
domain_name         = "justindemo.click"
hosted_zone_id      = "Z009936338M7HCAAPVULL"
subdomain_app       = "app"
subdomain_api       = "api"

vpc_cidr            = "10.0.0.0/16"
public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets     = ["10.0.11.0/24","10.0.12.0/24"]
azs                 = ["us-east-1a","us-east-1b"]

container_port      = 3000
container_cpu       = 256
container_memory    = 512
desired_count       = 2

dynamodb_table_name = "app-items"
jwt_audience        = ["app-client"]  # will be replaced by Cognito app client id output

github_org          = "justinidahosa"
github_repo         = "containerized-and-scalable-web-app"
image_tag           = "latest"