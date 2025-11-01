variable "project_name" {
  type        = string
  description = "Project name for bucket naming"
}
variable "cloudfront_oai_iam_arn" {
  description = "The IAM ARN of the CloudFront Origin Access Identity"
  type        = string
}