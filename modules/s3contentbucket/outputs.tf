# ====================
#
# Outputs
#
# ====================

output "bucket_content_regional_domain_name" {
  value = aws_s3_bucket.tf_bucket_content.bucket_regional_domain_name
}

output "bucket_content_id" {
  value = aws_s3_bucket.tf_bucket_content.id
}
