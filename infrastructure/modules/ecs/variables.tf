variable "project_name"          { 
    type = string 
}
variable "vpc_id"                { 
    type = string 
}
variable "private_subnet_ids"    { 
    type = list(string) 
}
variable "alb_security_group_id" { 
    type = string 
}
variable "target_group_arn"      { 
    type = string 
}
variable "alb_https_listener_arn"{ 
    type = string 
}
variable "ecr_repository_url"    { 
    type = string 
}
variable "image_tag"             { 
    type = string 
}
variable "container_port"        { 
    type = number 
}
variable "container_cpu"         { 
    type = number 
}
variable "container_memory"      { 
    type = number 
}
variable "desired_count"         { 
    type = number 
}
variable "dynamodb_table_name"   { 
    type = string 
}
