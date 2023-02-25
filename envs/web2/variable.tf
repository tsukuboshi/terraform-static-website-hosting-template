# ====================
#
# Variables
#
# ====================

variable "aws_region" {
  default = "ap-northeast-1"
  type    = string
}

variable "system" {
  default = "ex"
  type    = string
}

variable "project" {
  default = "swh"
  type    = string
}

variable "environment" {
  default = "test"
  type    = string
}

variable "naked_domain" {
  # default = "example.com"
  type = string
}

variable "sub_domain" {
  default = "scd"
  type    = string
}

variable "src_dir" {
  default = "../../src"
  type    = string
}

variable "internal" {
  default = true
  type    = bool
}

# CloudFront #
variable "default_origin_protocol_policy" {
  default = "redirect-to-https"
  type    = string
}

variable "default_origin_ssl_protocols" {
  default = ["TLSv1", "TLSv1.1", "TLSv1.2"]
  type    = list(any)
}

variable "default_cb_allowed_methods" {
  default = ["GET", "HEAD"]
  type    = list(any)
}

variable "default_cb_cached_methods" {
  default = ["GET", "HEAD"]
  type    = list(any)
}

variable "default_cb_viewer_protocol_policy" {
  default = "redirect-to-https"
  type    = string
}

variable "default_cb_compress" {
  default = true
  type    = bool
}

variable "cf_log_include_cookies" {
  default = false
  type    = bool
}

variable "cf_log_prefix" {
  default = "cloudfront"
  type    = string
}

# CloudFront Functions #
variable "function_file" {
  default = "basic_auth.js"
  type    = string
}

variable "basicauth_pass" {
  default = "password"
  type    = string
}

# S3 #
variable "object_expiration_days" {
  default = 366
  type    = number
}

variable "object_file" {
  default = "index.html"
  type    = string
}
