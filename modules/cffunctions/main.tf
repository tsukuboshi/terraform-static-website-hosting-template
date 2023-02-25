# ====================
#
# CloudFront Functions
#
# ====================

resource "aws_cloudfront_function" "basic_auth" {
  name    = "${var.system}-${var.project}-${var.environment}-cf-func"
  runtime = "cloudfront-js-1.0"
  publish = true
  code = templatefile("${var.src_dir}/${var.function_file}", {
    basicauth_pass = var.basicauth_pass
    }
  )
}
