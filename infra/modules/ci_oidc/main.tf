resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "gha_role" {
  name = "${var.project_name}-gha-oidc"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        },
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
        }
      }
    }]
  })
}


resource "aws_iam_policy" "gha_policy" {
  name   = "${var.project_name}-gha-policy"
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[
      { Effect="Allow", Action=["ecr:GetAuthorizationToken","ecr:BatchCheckLayerAvailability","ecr:CompleteLayerUpload","ecr:UploadLayerPart","ecr:InitiateLayerUpload","ecr:PutImage","ecr:BatchGetImage","ecr:DescribeRepositories"], Resource="*" },
      { Effect="Allow", Action=["ecs:DescribeServices","ecs:DescribeTaskDefinition","ecs:RegisterTaskDefinition","ecs:UpdateService"], Resource="*" },
      { Effect="Allow", Action=["iam:PassRole"], Resource="*", Condition={ StringLike={"iam:PassedToService":"ecs-tasks.amazonaws.com"} } },
      { Effect="Allow", Action=["logs:CreateLogStream","logs:PutLogEvents","logs:DescribeLogGroups"], Resource="*" },
      { Effect="Allow", Action=["s3:*"], Resource="*" },               
      { Effect="Allow", Action=["dynamodb:*"], Resource="*" },          
      { Effect="Allow", Action=["cloudfront:CreateInvalidation"], Resource="*" }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.gha_role.name
  policy_arn = aws_iam_policy.gha_policy.arn
}

