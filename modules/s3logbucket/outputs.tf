# ====================
#
# Outputs
#
# ====================

output "bucket_log" {
  value = aws_s3_bucket.tf_bucket_log.bucket
}
