resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    # GitHub's OIDC thumbprint (current root CA)
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

resource "aws_iam_role" "gha_oidc" {
  name = "${var.project_name}-gha-oidc"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            # Limit to your repo for security
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "gha_policy" {
  name        = "${var.project_name}-gha-policy"
  description = "Permissions for GitHub Actions OIDC role to deploy full AWS infrastructure via Terraform"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # Networking
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",

          # Compute / Containers
          "ecs:*",
          "ecr:*",

          # API + CDN
          "apigateway:*",
          "cloudfront:*",

          # DNS / Certificates
          "route53:*",
          "acm:*",

          # Data
          "dynamodb:*",
          "s3:*",

          # Auth / Security
          "cognito-idp:*",
          "iam:*",

          # Monitoring / Logging
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "gha_policy_attach" {
  role       = aws_iam_role.gha_oidc.name
  policy_arn = aws_iam_policy.gha_policy.arn
}

