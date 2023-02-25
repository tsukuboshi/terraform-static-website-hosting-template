# ====================
#
# Route53
#
# ====================

data "aws_route53_zone" "tf_route53_zone" {
  name = var.naked_domain
}

resource "aws_route53_record" "tf_route53_record_cf_access" {
  zone_id = data.aws_route53_zone.tf_route53_zone.id
  name    = var.environment == "test" ? "${var.sub_domain}.test.${var.naked_domain}" : "${var.sub_domain}.${var.naked_domain}"
  type    = "A"

  alias {
    name                   = var.record_alias_name
    zone_id                = var.record_alias_zone_id
    evaluate_target_health = true
  }
}
