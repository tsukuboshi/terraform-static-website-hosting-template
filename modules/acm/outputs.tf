# ====================
#
# Outputs
#
# ====================

output "acm_cf_cert_arn" {
  value = aws_acm_certificate.tf_acm_cf_cert.arn
}

output "acm_cf_cert_valid" {
  value = aws_acm_certificate_validation.tf_acm_cf_cert_valid
}
