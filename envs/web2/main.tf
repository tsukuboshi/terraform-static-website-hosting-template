# ====================
#
# Terraform
#
# ====================

terraform {
  required_version = ">=1.0.0"

  # backend "s3" {
  #   bucket = "tsukuboshi-bucket-tf-backend"
  #   key    = "terraform.tfstate"
  #   region = "ap-northeast-1"

  #   dynamodb_table = "tsukuboshi-ddb-tf-backend"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# ====================
#
# Provider
#
# ====================

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Prj = var.project
      Env = var.environment
    }
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  default_tags {
    tags = {
      Prj = var.project
      Env = var.environment
    }
  }
}

# ====================
#
# Modules
#
# ====================



module "acm" {
  source       = "../../modules/acm"
  system       = var.system
  project      = var.project
  environment  = var.environment
  naked_domain = var.naked_domain
  providers = {
    aws = aws.virginia
  }
}

module "cloudfront" {
  source                            = "../../modules/cloudfront"
  system                            = var.system
  project                           = var.project
  environment                       = var.environment
  sub_domain                        = var.sub_domain
  naked_domain                      = var.naked_domain
  object_file                       = var.object_file
  cf_origin_domain_name             = module.s3_content_bucket.bucket_content_regional_domain_name
  cf_origin_id                      = module.s3_content_bucket.bucket_content_id
  cf_log_bucket                     = module.s3_log_bucket.bucket_log
  cf_acm_cert_arn                   = module.acm.acm_cf_cert_arn
  cf_acm_cert_valid                 = module.acm.acm_cf_cert_valid
  default_cache_policy_id           = module.cfpolicy.caching_enabled_id
  default_origin_request_policy_id  = module.cfpolicy.query_strings_all_id
  default_origin_protocol_policy    = var.default_origin_protocol_policy
  default_origin_ssl_protocols      = var.default_origin_ssl_protocols
  default_cb_allowed_methods        = var.default_cb_allowed_methods
  default_cb_cached_methods         = var.default_cb_cached_methods
  default_cb_viewer_protocol_policy = var.default_cb_viewer_protocol_policy
  default_cb_compress               = var.default_cb_compress
  cf_log_include_cookies            = var.cf_log_include_cookies
  cf_log_prefix                     = var.cf_log_prefix
  cf_event_type                     = "viewer-request"
  cf_function_arn                   = module.cffunctions.cf_function_arn
}

module "cffunctions" {
  source         = "../../modules/cffunctions"
  system         = var.system
  project        = var.project
  environment    = var.environment
  src_dir        = var.src_dir
  function_file  = var.function_file
  basicauth_pass = var.basicauth_pass
}

module "cfpolicy" {
  source      = "../../modules/cfpolicy"
  system      = var.system
  project     = var.project
  environment = var.environment
}

module "route53" {
  source               = "../../modules/route53"
  system               = var.system
  project              = var.project
  environment          = var.environment
  sub_domain           = var.sub_domain
  naked_domain         = var.naked_domain
  record_alias_name    = module.cloudfront.cf_distr_domain_name
  record_alias_zone_id = module.cloudfront.cf_distr_hosted_zone_id
}

module "s3_content_bucket" {
  source            = "../../modules/s3contentbucket"
  system            = var.system
  project           = var.project
  environment       = var.environment
  src_dir           = var.src_dir
  object_file       = var.object_file
  internal          = var.internal
  cf_s3_oai_iam_arn = module.cloudfront.cf_s3_oai_iam_arn
  s3_log_bucket     = module.s3_log_bucket.bucket_log
}

module "s3_log_bucket" {
  source                 = "../../modules/s3logbucket"
  system                 = var.system
  project                = var.project
  environment            = var.environment
  internal               = var.internal
  object_expiration_days = var.object_expiration_days
}
