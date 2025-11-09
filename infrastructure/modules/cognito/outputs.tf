output "user_pool_id" {
  value = aws_cognito_user_pool.up.id
}

output "jwt_issuer" {
  value = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.up.id}"
}

output "app_client_id" {
  value = aws_cognito_user_pool_client.client.id
}
