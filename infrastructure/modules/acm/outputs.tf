output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
output "validated_certificate_arn" {
  value = aws_acm_certificate_validation.validated.certificate_arn
}
