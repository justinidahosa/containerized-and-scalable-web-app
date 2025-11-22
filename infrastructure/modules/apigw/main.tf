resource "aws_cloudwatch_log_group" "api" {
  name              = "/apigw/${var.api_name}"
  retention_in_days = 14
}

resource "aws_apigatewayv2_api" "api" {
  name          = var.api_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id           = aws_apigatewayv2_api.api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito"
  jwt_configuration {
    audience = [var.audience_client_id]
    issuer   = var.cognito_issuer
  }
  depends_on = [aws_apigatewayv2_integration.alb]
}

# HTTPS to ALB using custom hostname (api.justindemo.click)
resource "aws_apigatewayv2_integration" "alb" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "https://${var.alb_custom_host}" # api.justindemo.click
  payload_format_version = "1.0"
}

# Any under /api/*
resource "aws_apigatewayv2_route" "any_api" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "ANY /api/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.alb.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
  authorization_type = "JWT"
}

# Health without auth
resource "aws_apigatewayv2_route" "health_api" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "GET /api/health"
  target             = "integrations/${aws_apigatewayv2_integration.alb.id}"
  authorization_type = "NONE"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = var.stage_name # "$default" or "prod"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api.arn
    format = jsonencode({
      requestId = "$context.requestId",
      routeKey  = "$context.routeKey",
      status    = "$context.status"
    })
  }
  default_route_settings {
    throttling_burst_limit   = 100
    throttling_rate_limit    = 50
    detailed_metrics_enabled = true
  }
}
