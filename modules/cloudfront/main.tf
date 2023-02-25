# ====================
#
# Cache Distribution
#
# ====================
resource "aws_cloudfront_distribution" "tf_cloudfront_distribution" {

  origin {
    domain_name = var.cf_origin_domain_name
    origin_id   = var.cf_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.tf_cf_s3_origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = var.default_cb_allowed_methods
    cached_methods  = var.default_cb_cached_methods

    target_origin_id = var.cf_origin_id

    viewer_protocol_policy = var.default_cb_viewer_protocol_policy

    cache_policy_id          = var.default_cache_policy_id
    origin_request_policy_id = var.default_origin_request_policy_id

    compress = var.default_cb_compress

    dynamic "function_association" {
      for_each = var.environment == "test" ? { dummy : "hoge" } : {}
      content {
        event_type   = var.cf_event_type
        function_arn = var.cf_function_arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = [var.environment == "test" ? "${var.sub_domain}.test.${var.naked_domain}" : "${var.sub_domain}.${var.naked_domain}"]

  default_root_object = var.object_file

  comment = var.sub_domain

  enabled         = "true"
  is_ipv6_enabled = "false"
  price_class     = "PriceClass_All"

  logging_config {
    include_cookies = var.cf_log_include_cookies
    bucket          = "${var.cf_log_bucket}.s3.amazonaws.com"
    prefix          = var.cf_log_prefix
  }

  viewer_certificate {
    acm_certificate_arn      = var.cf_acm_cert_arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  depends_on = [
    var.cf_acm_cert_valid
  ]
}

resource "aws_cloudfront_origin_access_identity" "tf_cf_s3_origin_access_identity" {}
