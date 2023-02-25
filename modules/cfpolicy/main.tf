
# ====================
#
# CloudFront Policy
#
# ====================


# data "aws_cloudfront_cache_policy" "caching_disabled" {
#   name = "Managed-CachingDisabled"
# }

resource "aws_cloudfront_cache_policy" "caching_enabled" {
  name = "${var.system}-${var.project}-${var.environment}-caching-enabled"

  default_ttl = 300
  max_ttl     = 600
  min_ttl     = 60

  parameters_in_cache_key_and_forwarded_to_origin {

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "query_strings_all" {
  name = "${var.system}-${var.project}-${var.environment}-query-strings-all"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}
