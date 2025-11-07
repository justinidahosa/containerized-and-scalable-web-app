output "issuer_url" {
  value = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.up.id}"
}
output "user_pool_client_id" { 
    value = aws_cognito_user_pool_client.client.id 
}
