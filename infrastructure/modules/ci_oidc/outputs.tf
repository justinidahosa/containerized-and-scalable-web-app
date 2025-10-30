output "gha_role_arn" {
  description = "GitHub Actions OIDC role ARN to use in workflow"
  value       = aws_iam_role.gha_oidc.arn
}
