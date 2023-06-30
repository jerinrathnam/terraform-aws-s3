
data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
  bucket_id  = var.create_s3_bucket == false ? var.s3_bucket_name : aws_s3_bucket.this[0].id
}

# S3 BUCKET

resource "aws_s3_bucket" "this" {
  count = var.create_s3_bucket ? 1 : 0

  bucket              = var.s3_bucket_name != null ? var.s3_bucket_name : "${lower(var.name)}-${local.account_id}"
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled

  tags = merge(
    {
      "Name" = var.s3_bucket_name != null ? var.s3_bucket_name : "${lower(var.name)}-${local.account_id}"
    },
    var.tags
  )
}

# BUCKET ACCELERATE CONFIGURATION

resource "aws_s3_bucket_accelerate_configuration" "this" {
  count = var.enable_bucket_accelerate ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner
  status                = "Enabled"
}

# BUCKET ACL

resource "aws_s3_bucket_acl" "this" {
  count = var.bucket_acl != null ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner
  acl                   = var.bucket_acl

  dynamic "access_control_policy" {
    for_each = var.access_control_policy == null ? [] : [var.access_control_policy]

    content {
      dynamic "grant" {
        for_each = var.access_control_policy.grant

        content {
          dynamic "grantee" {
            for_each = grant.value.grantee

            content {
              email_address = lookup(grantee.value, "email_address", null)
              id            = lookup(grantee.value, "id", null)
              type          = lookup(grantee.value, "type", null)
              uri           = lookup(grantee.value, "uri", null)
            }
          }
          permission = grant.value.permission
        }
      }

      dynamic "owner" {
        for_each = var.access_control_policy.owner

        content {
          id           = lookup(owner.value, "id", null)
          display_name = lookup(owner.value, "display_name", null)
        }
      }
    }
  }
}

# BUCKET_ANALYTICS CONFIGURATION

resource "aws_s3_bucket_analytics_configuration" "this" {
  count = var.enable_bucket_analytics_configuration ? 1 : 0

  bucket = local.bucket_id
  name   = var.bucket_analytics_configuration_name

  dynamic "filter" {
    for_each = var.bucket_analytics_configuration_filter == null ? [] : [var.bucket_analytics_configuration_filter]

    content {
      prefix = lookup(filter.value, "prefix", null)
      tags   = try(each.value.filter.tags, null)
    }
  }

  dynamic "storage_class_analysis" {
    for_each = var.storage_class_analysis == null ? [] : [var.storage_class_analysis]

    content {
      dynamic "data_export" {
        for_each = storage_class_analysis.value.data_export_destination

        content {
          output_schema_version = "V_1"
          destination {
            s3_bucket_destination {
              bucket_arn        = lookup(storage_class_analysis.value, "bucket_arn", null)
              bucket_account_id = lookup(storage_class_analysis.value, "bucket_account_id", null)
              format            = lookup(storage_class_analysis.value, "format", null)
              prefix            = lookup(storage_class_analysis.value, "prefix", null)
            }
          }
        }
      }
    }
  }
}

# BUCKET CORS CONFIGURATION

resource "aws_s3_bucket_cors_configuration" "this" {
  count = var.enable_cors_configuration ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      id              = lookup(cors_rule.value, "id", null)
      allowed_methods = lookup(cors_rule.value, "allowed_methods", null)
      allowed_origins = lookup(cors_rule.value, "allowed_origins", null)
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }
}

# BUCKET INTELLIGENT TIERING CONFIGURATION

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count = var.enable_bucket_intelligent_tiering ? 1 : 0

  bucket = local.bucket_id
  name   = var.bucket_intelligent_tiering_name
  status = var.bucket_intelligent_tiering_status

  dynamic "filter" {
    for_each = var.bucket_intelligent_tiering_filter == null ? [] : [var.bucket_intelligent_tiering_filter]

    content {
      prefix = lookup(filter.value, "prefix", null)
      tags   = try(each.value.filter.tags, null)
    }
  }

  dynamic "tiering" {
    for_each = var.bucket_intelligent_tiering_block

    content {
      access_tier = tiering.value.access_tier
      days        = tiering.value.days
    }
  }
}

# BUCKET INVENTORY

resource "aws_s3_bucket_inventory" "this" {
  count = var.enable_s3_bucket_inventory ? 1 : 0

  bucket                   = local.bucket_id
  name                     = var.s3_bucket_inventory_name
  enabled                  = var.s3_bucket_inventory_enabled
  included_object_versions = var.included_object_versions

  schedule {
    frequency = var.s3_bucket_inventory_frequency
  }

  dynamic "filter" {
    for_each = var.s3_bucket_inventory_filter == null ? [] : [var.s3_bucket_inventory_filter]

    content {
      prefix = lookup(filter.value, "prefix", null)
    }
  }


  destination {
    bucket {
      format     = var.s3_bucket_inventory_destination.format
      bucket_arn = var.s3_bucket_inventory_destination.bucket_arn
      prefix     = var.s3_bucket_inventory_destination.prefix
      account_id = var.s3_bucket_inventory_destination.account_id

      dynamic "encryption" {
        for_each = var.s3_bucket_inventory_destination.encryption == null ? [] : [var.s3_bucket_inventory_destination.encryption]

        content {

          dynamic "sse_kms" {
            for_each = encryption.value.sse_kms == null ? [] : [encryption.value.sse_kms]

            content {
              key_id = sse_kms.value.key_id
            }
          }

          dynamic "sse_s3" {
            for_each = encryption.value.sse_s3 == null ? [] : [encryption.value.sse_s3]

            content {

            }
          }
        }
      }
    }
  }
}

# BUCKET LIFECYCLE CINFIGURATION

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.enable_lifecycle_configuration ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = var.lifecycle_configuration_rule

    content {
      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload == null ? [] : [rule.value.abort_incomplete_multipart_upload]

        content {
          days_after_initiation = lookup(abort_incomplete_multipart_upload.value, "days_after_initiation", null)
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration == null ? [] : [rule.value.expiration]

        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "filter" {
        for_each = rule.value.filter == null ? [] : [rule.value.filter]

        content {
          dynamic "and" {
            for_each = filter.value.and == null ? [] : [rule.value.and]

            content {
              object_size_greater_than = lookup(and.value, "object_size_greater_than", null)
              object_size_less_than    = lookup(and.value, "object_size_less_than", null)
              prefix                   = lookup(and.value, "prefix", null)

              tags = try(each.value.filter.tags, null)
            }
          }

          object_size_greater_than = lookup(filter.value, "object_size_greater_than", null)
          object_size_less_than    = lookup(filter.value, "object_size_less_than", null)
          prefix                   = lookup(filter.value, "prefix", null)

          dynamic "tag" {
            for_each = filter.value.tags == null ? {} : filter.value.tags

            content {
              key   = each.key
              value = each.value
            }
          }
        }
      }

      id = rule.value.id

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration == null ? [] : [rule.value.noncurrent_version_expiration]

        content {
          newer_noncurrent_versions = lookup(noncurrent_version_expiration.value, "newer_noncurrent_versions", null)
          noncurrent_days           = lookup(noncurrent_version_expiration.value, "noncurrent_days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition == null ? [] : rule.value.noncurrent_version_transition

        content {
          newer_noncurrent_versions = lookup(noncurrent_version_transition.value, "newer_noncurrent_versions", null)
          noncurrent_days           = lookup(noncurrent_version_transition.value, "noncurrent_days", null)
          storage_class             = lookup(noncurrent_version_transition.value, "storage_class", null)
        }
      }

      status = rule.value.status

      dynamic "transition" {
        for_each = rule.value.transition == null ? [] : rule.value.transition

        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = lookup(transition.value, "storage_class", null)
        }
      }
    }
  }
}

# BUCKET LOGGING

resource "aws_s3_bucket_logging" "this" {
  count = var.enable_bucket_logging ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner
  target_bucket         = var.bucket_logging_target_bucket != null ? var.bucket_logging_target_bucket : aws_s3_bucket.this[0].id
  target_prefix         = var.bucket_logging_target_prefix

  dynamic "target_grant" {
    for_each = var.bucket_logging_target_grant == null ? [] : var.bucket_logging_target_grant

    content {
      permission = target_grant.value.permission

      dynamic "grantee" {
        for_each = target_grant.value.grantee

        content {
          email_address = lookup(grantee.value, "email_address", null)
          id            = lookup(grantee.value, "id", null)
          type          = lookup(grantee.value, "type", null)
          uri           = lookup(grantee.value, "uri", null)
        }
      }
    }
  }
}

# BUCKET METRIC

resource "aws_s3_bucket_metric" "this" {
  count = var.enable_bucket_metric ? 1 : 0

  bucket = local.bucket_id
  name   = var.bucket_metric_name

  dynamic "filter" {
    for_each = var.bucket_metric_filter == null ? [] : [var.bucket_metric_filter]

    content {
      prefix = filter.value.prefix
      tags   = try(each.value.filter.tags, null)
    }
  }
}

# BUCKET NOTIFICATION

resource "aws_s3_bucket_notification" "this" {
  count = var.enable_bucket_notification ? 1 : 0

  bucket      = local.bucket_id
  eventbridge = var.bucket_notification_event_bridge

  dynamic "lambda_function" {
    for_each = var.bucket_notification_lambda_function == null ? [] : var.bucket_notification_lambda_function

    content {
      events              = lookup(lambda_function.value, "events", null)
      filter_prefix       = lookup(lambda_function.value, "filter_prefix", null)
      filter_suffix       = lookup(lambda_function.value, "filter_suffix", null)
      id                  = lookup(lambda_function.value, "id", null)
      lambda_function_arn = lookup(lambda_function.value, "lambda_function_arn", null)
    }
  }

  dynamic "queue" {
    for_each = var.bucket_notification_queue == null ? [] : var.bucket_notification_queue

    content {
      events        = lookup(queue.value, "events", null)
      filter_prefix = lookup(queue.value, "filter_prefix", null)
      filter_suffix = lookup(queue.value, "filter_suffix", null)
      id            = lookup(queue.value, "id", null)
      queue_arn     = lookup(queue.value, "queue_arn", null)
    }
  }

  dynamic "topic" {
    for_each = var.bucket_notification_topic == null ? [] : var.bucket_notification_topic

    content {
      events        = lookup(topic.value, "events", null)
      filter_prefix = lookup(topic.value, "filter_prefix", null)
      filter_suffix = lookup(topic.value, "filter_suffix", null)
      id            = lookup(topic.value, "id", null)
      topic_arn     = lookup(topic.value, "topic_arn", null)
    }
  }
}

# BUCKET OBJECT LOCK CONFIGURATION

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = var.enable_object_lock ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner
  token                 = var.object_lock_token
  object_lock_enabled   = "Enabled"

  dynamic "rule" {
    for_each = var.object_lock_rule == null ? [] : [var.object_lock_rule]

    content {
      default_retention {
        days  = lookup(rule.value, "days", null)
        mode  = lookup(rule.value, "mode", null)
        years = lookup(rule.value, "years", null)
      }
    }
  }
}

# BUCKET OWNERSHIP CONTROLS

resource "aws_s3_bucket_ownership_controls" "this" {
  count = var.enable_ownership_control ? 1 : 0

  bucket = local.bucket_id

  rule {
    object_ownership = var.object_ownership
  }
}

# BUCKET POLICY


resource "aws_s3_bucket_policy" "this" {
  count = var.create_bucket_policy ? 1 : 0

  bucket = local.bucket_id

  policy = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.create_bucket_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.bucket_policy_statements

    content {
      sid       = lookup(statement.value, "sid", null)
      effect    = lookup(statement.value, "effect", null)
      actions   = lookup(statement.value, "actions", null)
      resources = lookup(statement.value, "resources", null)

      dynamic "principals" {
        for_each = statement.value.principals == null ? [] : statement.value.principals

        content {
          type        = principals.value.principal_type
          identifiers = principals.value.principal_identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition == null ? [] : statement.value.condition

        content {
          test     = lookup(condition.value, "condition_test", null)
          variable = lookup(condition.value, "condition_variable", null)
          values   = lookup(condition.value, "condition_values", null)
        }
      }
    }
  }
}

# BUCKET PUBLIC ACCESS BLOCK

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = local.bucket_id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# BUCKET REQUEST PAYMENT CONFIGURATION 

resource "aws_s3_bucket_request_payment_configuration" "this" {
  count = var.enable_request_payment ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner
  payer                 = var.request_payment_payer
}

# BUCKET SERVER SIDE ENCRYPTION CONFIGURATION

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.enable_server_side_encryption ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = var.server_side_encryption_rule

    content {
      bucket_key_enabled = lookup(rule.value, "bucket_key_enabled", null)

      dynamic "apply_server_side_encryption_by_default" {
        for_each = rule.value.apply_server_side_encryption_by_default == null ? [] : [rule.value.apply_server_side_encryption_by_default]

        content {
          sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
          kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
        }
      }
    }
  }
}

# BUCKET VERSIONING

resource "aws_s3_bucket_versioning" "this" {
  count = var.enable_bucket_versioning ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner

  versioning_configuration {
    status     = var.versioning_configuration_status
    mfa_delete = var.versioning_configuration_mfa_delete
  }

  mfa = var.bucket_versioning_mfa
}

# BUCKET WEBSITE CONFIGURATION

resource "aws_s3_bucket_website_configuration" "this" {
  count = var.enable_static_website ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "error_document" {
    for_each = var.static_website_error_document == null ? [] : [var.static_website_index_document]

    content {
      key = error_document.value.key
    }
  }

  dynamic "index_document" {
    for_each = var.static_website_index_document == null ? [] : [var.static_website_index_document]

    content {
      suffix = index_document.value.suffix
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = var.static_website_redirect == null ? [] : [var.static_website_redirect]

    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = lookup(redirect_all_requests_to.value, "protocol", null)
    }
  }

  dynamic "routing_rule" {
    for_each = var.static_website_routing_rule == null ? [] : var.static_website_routing_rule

    content {
      redirect {
        host_name               = lookup(routing_rule.redirect.value, "hostname", null)
        http_redirect_code      = lookup(routing_rule.redirect.value, "http_redirect_code", null)
        protocol                = lookup(routing_rule.redirect.value, "protocol", null)
        replace_key_prefix_with = lookup(routing_rule.redirect.value, "replace_key_prefix_with", null)
        replace_key_with        = lookup(routing_rule.redirect.value, "replace_key_with", null)
      }

      dynamic "condition" {
        for_each = routing_rule.value.condition == null ? [] : [routing_rule.value.condition]

        content {
          http_error_code_returned_equals = lookup(condition.value, "http_error_code_returned_equals", null)
          key_prefix_equals               = lookup(condition.value, "key_prefix_equals", null)
        }
      }
    }
  }

  routing_rules = var.static_website_routing_rules
}

# S3 OBJECT

resource "aws_s3_object" "this" {
  count = var.create_s3_object ? 1 : 0

  bucket                        = local.bucket_id
  key                           = var.s3_object_key
  acl                           = var.s3_object_acl
  bucket_key_enabled            = var.s3_object_key_enabled
  content_base64                = var.s3_object_content_base64
  content_disposition           = var.s3_object_content_disposition
  content_encoding              = var.s3_object_content_encoding
  content_language              = var.s3_object_content_language
  content_type                  = var.s3_object_content_type
  content                       = var.s3_object_content
  etag                          = var.s3_object_etag
  force_destroy                 = var.s3_object_force_destroy
  kms_key_id                    = var.s3_object_kms_key_id
  metadata                      = var.s3_object_metadata
  object_lock_legal_hold_status = var.s3_object_lock_legal_hold_status
  object_lock_mode              = var.s3_object_lock_mode
  object_lock_retain_until_date = var.s3_object_lock_retain_until_date
  server_side_encryption        = var.s3_object_server_side_encryption
  source                        = var.s3_object_source
  source_hash                   = var.s3_object_source_hash
  storage_class                 = var.s3_object_storage_class
  website_redirect              = var.s3_object_website_redirect
}

# S3 OBJECT COPY

resource "aws_s3_object_copy" "this" {
  count = var.copy_s3_object ? 1 : 0

  bucket                        = local.bucket_id
  key                           = var.copy_s3_object_key
  source                        = var.copy_s3_object_source
  acl                           = var.copy_s3_object_acl
  content_disposition           = var.copy_s3_object_content_disposition
  content_encoding              = var.copy_s3_object_content_encoding
  content_language              = var.copy_s3_object_content_language
  content_type                  = var.copy_s3_object_content_type
  copy_if_match                 = var.copy_s3_object_copy_if_match
  copy_if_none_match            = var.copy_s3_object_copy_if_none_match
  copy_if_modified_since        = var.copy_s3_object_copy_if_modified_since
  copy_if_unmodified_since      = var.copy_s3_object_copy_if_unmodified_since
  customer_algorithm            = var.copy_s3_object_customer_algorithm
  customer_key                  = var.copy_s3_object_customer_key
  customer_key_md5              = var.copy_s3_object_customer_key_md5
  expected_bucket_owner         = var.copy_s3_object_expected_bucket_owner
  expected_source_bucket_owner  = var.copy_s3_object_expected_source_bucket_owner
  expires                       = var.copy_s3_object_expires
  force_destroy                 = var.copy_s3_object_force_destroy
  kms_encryption_context        = var.copy_s3_object_kms_encryption_context
  kms_key_id                    = var.copy_s3_object_kms_key_id
  metadata                      = var.copy_s3_object_metadata
  metadata_directive            = var.copy_s3_object_metadata_directive
  object_lock_legal_hold_status = var.copy_s3_object_lock_legal_hold_status
  object_lock_mode              = var.copy_s3_object_lock_mode
  object_lock_retain_until_date = var.copy_s3_object_lock_retain_until_date
  request_payer                 = var.copy_s3_object_request_payer
  server_side_encryption        = var.copy_s3_object_server_side_encryption
  source_customer_algorithm     = var.copy_s3_object_source_customer_algorithm
  source_customer_key           = var.copy_s3_object_source_customer_key
  source_customer_key_md5       = var.copy_s3_object_source_customer_key_md5
  storage_class                 = var.copy_s3_object_storage_class
  tagging_directive             = var.copy_s3_object_tagging_directive
  website_redirect              = var.copy_s3_object_website_redirect

  dynamic "grant" {
    for_each = var.object_copy_grant == null ? [] : [var.object_copy_grant]

    content {
      uri         = lookup(grant.value, "uri", null)
      type        = lookup(grant.value, "type", null)
      permissions = lookup(grant.value, "permissions", null)
      email       = lookup(grant.value, "email", null)
      id          = lookup(grant.value, "id", null)
    }
  }
}