output "app_fqdn" { 
    value = "${var.subdomain_app}.${var.domain_name}" 
}
output "api_fqdn" { 
    value = "${var.subdomain_api}.${var.domain_name}" 
}
