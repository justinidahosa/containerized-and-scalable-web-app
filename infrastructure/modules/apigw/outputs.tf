output "api_url"         { 
    value = aws_apigatewayv2_stage.stage.invoke_url 
}
output "api_domain_name" {
  value = replace(aws_apigatewayv2_api.api.api_endpoint, "https://", "")
}

output "api_id"          { 
    value = aws_apigatewayv2_api.api.id 
}