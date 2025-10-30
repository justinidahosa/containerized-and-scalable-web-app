resource "aws_cognito_user_pool" "cognito_pool" {
  name = "${var.project_name}-userpool"
  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]
}

resource "aws_cognito_user_pool_client" "app" {
  name                         = "${var.project_name}-client"
  user_pool_id                 = aws_cognito_user_pool.cognito_pool.id
  generate_secret              = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows         = ["code"]
  allowed_oauth_scopes        = ["email","openid","profile"]
  callback_urls               = var.callback_urls
  logout_urls                 = var.logout_urls
  supported_identity_providers = ["COGNITO"]
}
