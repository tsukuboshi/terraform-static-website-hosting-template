# ====================
#
# S3 Log Bucket
#
# ====================

data "aws_caller_identity" "tf_caller_identity" {}

resource "aws_s3_bucket" "tf_bucket_log" {
  bucket        = "${var.system}-${var.project}-${var.environment}-log-${data.aws_caller_identity.tf_caller_identity.account_id}"
  force_destroy = var.internal
}

resource "aws_s3_bucket_public_access_block" "tf_public_access_block_cf_log" {
  bucket                  = aws_s3_bucket.tf_bucket_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "tf_bucket_versioning_log" {
  bucket = aws_s3_bucket.tf_bucket_log.id
  versioning_configuration {
    status = var.internal == true ? "Disabled" : "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "tf_bucket_lifecycle_configuration_log" {
  bucket = aws_s3_bucket.tf_bucket_log.id
  rule {
    id = "${var.system}-${var.project}-${var.environment}-log-${data.aws_caller_identity.tf_caller_identity.account_id}-lifecycle"
    expiration {
      days = var.object_expiration_days
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_bucket_encrypt_config_log" {
  bucket = aws_s3_bucket.tf_bucket_log.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_policy" "tf_s3_bucket_policy_log" {
  bucket = aws_s3_bucket.tf_bucket_log.id
  policy = data.aws_iam_policy_document.tf_iam_policy_document_log.json
}

data "aws_iam_policy_document" "tf_iam_policy_document_log" {
  statement {
    sid = "S3ServerAccessLogsPolicy"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.tf_bucket_log.arn}/*"
    ]
    principals {
      type = "Service"
      identifiers = [
        "logging.s3.amazonaws.com"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:s3:::${var.system}-${var.project}-${var.environment}-content-${data.aws_caller_identity.tf_caller_identity.account_id}"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        "${data.aws_caller_identity.tf_caller_identity.account_id}"
      ]
    }
  }
}
