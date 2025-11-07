variable "domain_name"   { 
    type = string 
}
variable "alt_names"     { 
    type = list(string) 
    default = [] 
}
variable "hosted_zone_id"{ 
    type = string 
}
