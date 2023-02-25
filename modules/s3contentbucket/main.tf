# ====================
#
# S3 Content Bucket
#
# ====================

data "aws_caller_identity" "tf_caller_identity" {}

resource "aws_s3_bucket" "tf_bucket_content" {
  bucket        = "${var.system}-${var.project}-${var.environment}-content-${data.aws_caller_identity.tf_caller_identity.account_id}"
  force_destroy = var.internal
}

resource "aws_s3_bucket_public_access_block" "tf_public_access_block_content" {
  bucket                  = aws_s3_bucket.tf_bucket_content.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "tf_bucket_versioning_content" {
  bucket = aws_s3_bucket.tf_bucket_content.id
  versioning_configuration {
    status = var.internal == true ? "Disabled" : "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "tf_bucket_ownership_controls_content" {
  bucket = aws_s3_bucket.tf_bucket_content.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
resource "aws_s3_bucket_logging" "tf_s3_bucket_logging" {
  bucket = aws_s3_bucket.tf_bucket_content.id

  target_bucket = var.s3_log_bucket
  target_prefix = "s3/"
}

resource "aws_s3_bucket_policy" "tf_s3_bucket_policy_content" {
  bucket = aws_s3_bucket.tf_bucket_content.id
  policy = data.aws_iam_policy_document.tf_iam_policy_document_content.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_bucket_encrypt_config_content" {
  bucket = aws_s3_bucket.tf_bucket_content.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


data "aws_iam_policy_document" "tf_iam_policy_document_content" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.cf_s3_oai_iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.tf_bucket_content.arn}/*"
    ]
  }
}

# resource "aws_s3_object" "index_page" {
#   count         = var.internal == "true" ? 1 : 0
#   bucket        = aws_s3_bucket.tf_bucket_content.id
#   key           = var.object_file
#   source        = "${var.src_dir}/${var.object_file}"
#   etag          = filemd5("${var.src_dir}/${var.object_file}")
#   content_type  = "text/html"
#   force_destroy = var.internal == "true" ? "true" : "false"
# }
