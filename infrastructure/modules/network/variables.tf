variable "project_name"   { 
    type = string 
}
variable "vpc_cidr"       { 
    type = string 
}
variable "public_subnets" { 
    type = list(string) 
}
variable "private_subnets"{ 
    type = list(string) 
}
variable "azs"            { 
    type = list(string) 
}
