# ====================
#
# ACM Certificate
#
# ====================
resource "aws_acm_certificate" "tf_acm_cf_cert" {
  domain_name               = var.environment == "test" ? "test.${var.naked_domain}" : "${var.naked_domain}"
  subject_alternative_names = [var.environment == "test" ? "*.test.${var.naked_domain}" : "*.${var.naked_domain}"]
  validation_method         = "DNS"
  provider                  = aws

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.system}-${var.project}-${var.environment}-acm-cf"
  }
}


# ====================
#
# ACM DNS Verifycation
#
# ====================

data "aws_route53_zone" "tf_route53_zone" {
  name = var.naked_domain
}

resource "aws_route53_record" "tf_route53_record_acm_cf_dns_resolve" {
  for_each = {
    for dvo in aws_acm_certificate.tf_acm_cf_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 600
  type            = each.value.type
  zone_id         = data.aws_route53_zone.tf_route53_zone.zone_id
}


resource "aws_acm_certificate_validation" "tf_acm_cf_cert_valid" {
  certificate_arn         = aws_acm_certificate.tf_acm_cf_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.tf_route53_record_acm_cf_dns_resolve : record.fqdn]
  provider                = aws
}
