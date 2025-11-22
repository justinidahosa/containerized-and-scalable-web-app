resource "aws_cognito_user_pool" "up" {
  name = "app-users"
}
resource "aws_cognito_user_pool_client" "client" {
  name                                 = "app-client"
  user_pool_id                         = aws_cognito_user_pool.up.id
  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  supported_identity_providers         = ["COGNITO"]
}
resource "aws_cognito_user_pool_domain" "d" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.up.id
}