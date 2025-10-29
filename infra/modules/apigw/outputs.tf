output "api_domain_name" {
  description = "API Gateway target domain name (for Route 53 alias)"
  value       = aws_apigatewayv2_domain_name.apigw_domain_name.domain_name_configuration[0].target_domain_name
}

output "api_hosted_zone_id" {
  description = "API Gateway hosted zone ID"
  value       = aws_apigatewayv2_domain_name.apigw_domain_name.domain_name_configuration[0].hosted_zone_id
}
