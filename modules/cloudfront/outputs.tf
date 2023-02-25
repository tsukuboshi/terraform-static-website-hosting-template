# ====================
#
# Outputs
#
# ====================

output "cf_distr_domain_name" {
  value = aws_cloudfront_distribution.tf_cloudfront_distribution.domain_name
}

output "cf_distr_hosted_zone_id" {
  value = aws_cloudfront_distribution.tf_cloudfront_distribution.hosted_zone_id
}

output "cf_s3_oai_iam_arn" {
  value = aws_cloudfront_origin_access_identity.tf_cf_s3_origin_access_identity.iam_arn
}
