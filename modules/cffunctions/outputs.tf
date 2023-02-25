# ====================
#
# Outputs
#
# ====================

output "cf_function_arn" {
  value = aws_cloudfront_function.basic_auth.arn
}
