# ====================
#
# Outputs
#
# ====================

output "caching_enabled_id" {
  value = aws_cloudfront_cache_policy.caching_enabled.id
}

output "query_strings_all_id" {
  value = aws_cloudfront_origin_request_policy.query_strings_all.id
}
