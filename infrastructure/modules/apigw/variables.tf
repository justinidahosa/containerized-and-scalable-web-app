variable "api_name" { type = string }
variable "stage_name" { type = string } # "$default" or "prod"
variable "audience_client_id" { type = string }
variable "cognito_issuer" { type = string }  # https://<prefix>.auth.us-east-1.amazoncognito.com
variable "alb_custom_host" { type = string } # "api.justindemo.click"
