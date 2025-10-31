output "certificate_arn" {
  description = "Issued ACM certificate ARN"
  value       = aws_acm_certificate_validation.cert_validation.certificate_arn
}