# ====================
#
# Outputs
#
# ====================

output "url_for_access" {
  value = "https://${module.route53.aws_route53_record_name}"
}
