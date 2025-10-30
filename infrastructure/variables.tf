variable "region"                 { 
    type = string 
}
variable "project_name"           { 
    type = string 
}
variable "domain_name"            { 
    type = string 
}   # e.g., example.com (already registered in Route53)
variable "hosted_zone_id"            { 
    type = string 
} 
variable "subdomain_app"          { 
    type = string 
}   # e.g., "app" -> app.example.com via CloudFront
variable "subdomain_api"          { 
    type = string 
}   # e.g., "api" -> api.example.com via API GW
variable "vpc_cidr"               { 
    type = string 
}
variable "public_subnets"         { 
    type = list(string) 
}
variable "private_subnets"        { 
    type = list(string) 
}
variable "azs"                    { 
    type = list(string) 
} # ["us-east-1a","us-east-1b"]
variable "container_port"         { 
    type = number 
}
variable "container_cpu"          { 
    type = number 
}   # 256, 512, etc
variable "container_memory"       { 
    type = number 
}   # 512, 1024, etc
variable "desired_count"          { 
    type = number 
}
variable "dynamodb_table_name"    { 
    type = string 
}
variable "jwt_audience"           { 
    type = list(string) 
} # for API GW JWT auth (Cognito app client id later)
variable "github_org"             { 
    type = string 
}   # e.g., "your-gh-user-or-org"
variable "github_repo"            { 
    type = string 
}   # e.g., "terraform-ecs-fargate-cloudfront"
variable "image_tag"              { 
    type = string 
}   # default "latest", can be overridden by CI

