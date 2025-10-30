variable "project_name"  { 
    type = string 
}
variable "region"        { 
    type = string 
}
variable "alb_full_name" { 
    type = string 
} # from aws_lb.this.arn_suffix or full name; we pass in from root
variable "cluster_name"  { 
    type = string 
}
variable "service_name"  { 
    type = string 
}
variable "ddb_table_name"{ 
    type = string 
}
