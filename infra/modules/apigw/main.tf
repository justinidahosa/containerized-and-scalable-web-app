resource "aws_apigatewayv2_api" "http" {
  name          = "${var.project_name}-httpapi"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id           = aws_apigatewayv2_api.http.id
  authorizer_type  = "JWT"
  name             = "${var.project_name}-jwt"
  identity_sources = ["$request.header.Authorization"]
  jwt_configuration {
    audience = var.jwt_audience
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${var.user_pool_id}"
  }
}

resource "aws_apigatewayv2_integration" "alb" {
  api_id                 = aws_apigatewayv2_api.http.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "https://${var.alb_dns_name}"
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "proxy" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "ANY /api/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.alb.id}"
  authorizer_id = aws_apigatewayv2_authorizer.jwt.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.http.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_domain_name" "apigw_domain_name" {
  domain_name = "${var.subdomain_api}.${var.domain_name}"
  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "map" {
  api_id      = aws_apigatewayv2_api.http.id
  domain_name = aws_apigatewayv2_domain_name.apigw_domain_name.id
  stage       = aws_apigatewayv2_stage.prod.id
}

