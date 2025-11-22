output "api_id" {
  value = aws_apigatewayv2_api.api.id
}
output "api_execute_url" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

