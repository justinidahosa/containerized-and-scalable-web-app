variable "github_org"        { 
    type = string 
}
variable "github_repo"       { 
    type = string 
}
variable "provider_thumbprint" { 
    type = string 
}
# Backend (from bootstrap; pass full ARNs and bucket name/prefix)
variable "state_bucket_name"     { 
    type = string 
}
variable "state_bucket_prefix"   { 
    type = string 
}
variable "lock_table_arn"        { 
    type = string 
}

# Deploy targets (from other modules in this same apply)
variable "ecr_repo_arn"          { 
    type = string 
}
variable "ecs_service_arn"       { 
    type = string 
}
variable "task_role_arn"         { 
    type = string 
}
variable "execution_role_arn"    { 
    type = string 
}