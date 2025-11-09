resource "aws_iam_openid_connect_provider" "gh" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.provider_thumbprint]
}

resource "aws_iam_role" "ci" {
  name = "github-actions-ci"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Federated = aws_iam_openid_connect_provider.gh.arn },
      Action    = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "tf_state" {
  name = "ci-tfstate-access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "ListStatePrefix",
        Effect    = "Allow",
        Action    = ["s3:ListBucket"],
        Resource  = "arn:aws:s3:::${var.state_bucket_name}",
        Condition = { StringLike = { "s3:prefix" : ["${var.state_bucket_prefix}*", ""] } }
      },
      {
        Sid      = "RWStateObjects",
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        Resource = "arn:aws:s3:::${var.state_bucket_name}/${var.state_bucket_prefix}*"
      },
      {
        Sid      = "StateLockTable",
        Effect   = "Allow",
        Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem", "dynamodb:UpdateItem", "dynamodb:DescribeTable", "dynamodb:Scan"],
        Resource = var.lock_table_arn
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_push" {
  name = "ci-ecr-push"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["ecr:GetAuthorizationToken"], Resource = "*" },
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchCheckLayerAvailability", "ecr:CompleteLayerUpload", "ecr:DescribeRepositories",
          "ecr:InitiateLayerUpload", "ecr:PutImage", "ecr:UploadLayerPart", "ecr:BatchGetImage", "ecr:ListTagsForResource"
        ],
        Resource = var.ecr_repo_arn
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_deploy" {
  name = "ci-ecs-deploy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["ecs:Describe*"], Resource = "*" },
      { Effect = "Allow", Action = ["ecs:RegisterTaskDefinition"], Resource = "*" },
      { Effect = "Allow", Action = ["ecs:UpdateService"], Resource = var.ecs_service_arn },
      {
        Effect    = "Allow",
        Action    = ["iam:PassRole"],
        Resource  = [var.task_role_arn, var.execution_role_arn],
        Condition = { StringEquals = { "iam:PassedToService" : "ecs-tasks.amazonaws.com" } }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "a1" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.tf_state.arn
}
resource "aws_iam_role_policy_attachment" "a2" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ecr_push.arn
}
resource "aws_iam_role_policy_attachment" "a3" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ecs_deploy.arn
}

resource "aws_iam_role_policy_attachment" "ci_admin" {
  role       = aws_iam_role.ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



