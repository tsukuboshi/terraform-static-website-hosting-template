# ====================
#
# Outputs
#
# ====================

output "aws_route53_record_name" {
  value = aws_route53_record.tf_route53_record_cf_access.name
}
