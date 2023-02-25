# ====================
#
# Variables
#
# ====================

variable "system" {}

variable "project" {}

variable "environment" {}

variable "sub_domain" {}

variable "naked_domain" {}

variable "object_file" {}

variable "cf_origin_domain_name" {}

variable "cf_origin_id" {}

variable "cf_log_bucket" {}

variable "cf_acm_cert_arn" {}

variable "cf_acm_cert_valid" {}

variable "default_cache_policy_id" {}

variable "default_origin_request_policy_id" {}

variable "cf_function_arn" {
  default = null
}

variable "cf_event_type" {
  default = null
}

variable "default_origin_protocol_policy" {}

variable "default_origin_ssl_protocols" {}

variable "default_cb_allowed_methods" {}

variable "default_cb_cached_methods" {}

variable "default_cb_viewer_protocol_policy" {}

variable "default_cb_compress" {}

variable "cf_log_include_cookies" {}

variable "cf_log_prefix" {}
