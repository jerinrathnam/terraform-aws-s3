# S3 BUCKET

variable "name" {
  type        = string
  description = "Name for this infrastructure"
  default     = null
}

variable "create_s3_bucket" {
  type        = bool
  description = "Whehter the S3 bucket for codepipeline should be create"
  default     = true
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the pipeline s3 bucket."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error."
  default     = true
}

variable "object_lock_enabled" {
  type        = bool
  description = "Indicates whether this bucket has an Object Lock configuration enabled."
  default     = false
}

variable "expected_bucket_owner" {
  type        = string
  description = "Account ID of the expected bucket owner."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for this bucket"
  default     = null
}

# BUCKET ACCELERATE CONFIGURATION

variable "enable_bucket_accelerate" {
  type        = bool
  description = "Whether S3 bucket acceleration should be enabled"
  default     = false
}

# BUCKET ACL

variable "bucket_acl" {
  type        = string
  description = "Canned ACL to apply to the bucket."
  default     = null
}

variable "access_control_policy" {
  type = object(
    {
      grant = object(
        {
          grantee = object(
            {
              email_address = optional(string)
              id            = optional(string)
              type          = string
              uri           = optional(string)
            }
          )
          permission = string
        }
      )
      owner = object(
        {
          id           = string
          display_name = optional(string)
        }
      )
    }
  )
  description = "Configuration block that sets the ACL permissions for an object per grantee."
  default     = null
}

# BUCKET_ANALYTICS CONFIGURATION

variable "enable_bucket_analytics_configuration" {
  type        = bool
  description = "Whether the bucket analytics configuration should be enabled"
  default     = false
}

variable "bucket_analytics_configuration_name" {
  type        = string
  description = "Unique identifier of the analytics configuration for the bucket."
  default     = null
}

variable "bucket_analytics_configuration_filter" {
  type = object(
    {
      prefix = optional(string)
      tags   = optional(map(any))
    }
  )
  description = "Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags"
  default     = null
}

variable "storage_class_analysis" {
  type = object(
    {
      data_export_destination = object(
        {
          bucket_arn        = string
          bucket_account_id = optional(string)
          format            = optional(string)
          prefix            = optional(string)
        }
      )
    }
  )
  description = "Configuration for the analytics data export"
  default     = null
}

# BUCKET CORS CONFIGURATION

variable "enable_cors_configuration" {
  type        = bool
  description = "Whether the CORS configuration should be enable"
  default     = false
}

variable "cors_rules" {
  type = list(
    object(
      {
        id              = optional(string)
        allowed_methods = list(string)
        allowed_origins = list(string)
        allowed_headers = optional(list(string))
        expose_headers  = optional(list(string))
        max_age_seconds = optional(number)
      }
    )
  )
  description = "Set of origins and methods (cross-origin access that you want to allow)"
  default     = null
}

# BUCKET INTELLIGENT TIERING CONFIGURATION

variable "enable_bucket_intelligent_tiering" {
  type        = bool
  description = "Whether the bucket intelligent tiering should be enabled"
  default     = false
}

variable "bucket_intelligent_tiering_name" {
  type        = string
  description = "Unique name used to identify the S3 Intelligent-Tiering configuration for the bucket."
  default     = null
}

variable "bucket_intelligent_tiering_status" {
  type        = string
  description = "Specifies the status of the configuration."
  default     = null
}

variable "bucket_intelligent_tiering_filter" {
  type = object(
    {
      prefix = optional(string)
      tags   = optional(map(string))
    }
  )
  description = "Bucket filter. The configuration only includes objects that meet the filter's criteria"
  default     = null
}

variable "bucket_intelligent_tiering_block" {
  type = list(
    object(
      {
        access_tier = string
        days        = number
      }
    )
  )
  description = "S3 Intelligent-Tiering storage class tiers of the configuration"
  default     = null
}

# BUCKET INVENTORY

variable "enable_s3_bucket_inventory" {
  type        = bool
  description = "Whether the bucket inventory should be enabled"
  default     = false
}

variable "s3_bucket_inventory_name" {
  type        = string
  description = "Unique identifier of the inventory configuration for the bucket."
  default     = null
}

variable "s3_bucket_inventory_enabled" {
  type        = bool
  description = "Specifies whether the inventory is enabled or disabled."
  default     = true
}

variable "included_object_versions" {
  type        = string
  description = "Object versions to include in the inventory list."
  default     = "All"
}

variable "s3_bucket_inventory_frequency" {
  type        = string
  description = "Specifies how frequently inventory results are produced."
  default     = "Daily"
}

variable "s3_bucket_inventory_filter" {
  type = object(
    {
      prefix = string
    }
  )
  description = "Prefix that an object must have to be included in the inventory results."
  default     = null
}

variable "s3_bucket_inventory_destination" {
  type = object(
    {
      format     = string
      bucket_arn = string
      prefix     = optional(string)
      account_id = optional(string)
      encryption = optional(
        object(
          {
            sse_s3 = optional(any)
            sse_kms = optional(
              object(
                {
                  key_id = optional(string)
                }
              )
            )
          }
        )
      )
    }
  )
  description = "Contains information about where to publish the inventory results"
  default     = null
}

# BUCKET LIFECYCLE CINFIGURATION

variable "enable_lifecycle_configuration" {
  type        = bool
  description = "Whether to enable bucket lifecycle configuration"
  default     = false
}

variable "lifecycle_configuration_rule" {
  type = list(
    object(
      {
        abort_incomplete_multipart_upload = optional(
          object(
            {
              days_after_initiation = number
            }
          )
        )
        expiration = optional(
          object(
            {
              date                         = optional(string)
              days                         = optional(number)
              expired_object_delete_marker = optional(bool)
            }
          )
        )
        filter = optional(
          object(
            {
              prefix                   = optional(string)
              object_size_greater_than = optional(number)
              object_size_less_than    = optional(number)
              tag                      = optional(map(string))
              and = optional(
                object(
                  {
                    prefix                   = optional(string)
                    object_size_greater_than = optional(number)
                    object_size_less_than    = optional(number)
                    tags = optional(
                      map(string)
                    )
                  }
                )
              )
            }
          )
        )
        id = string
        noncurrent_version_expiration = optional(
          object(
            {
              newer_noncurrent_version = optional(number)
              noncurrent_days          = optional(number)
            }
          )
        )
        noncurrent_version_transition = optional(
          list(
            object(
              {
                storage_class            = string
                newer_noncurrent_version = optional(number)
                noncurrent_days          = optional(number)
              }
            )
          )
        )
        status = string
        transition = optional(
          list(
            object(
              {
                date          = optional(string)
                days          = optional(number)
                storage_class = optional(string)
              }
            )
          )
        )
      }
    )
  )
  description = "List of configuration blocks describing the rules managing the replication"
  default     = null
}

# BUCKET LOGGING

variable "enable_bucket_logging" {
  type        = bool
  description = "Whether to enable bucket logging"
  default     = false
}

variable "bucket_logging_target_bucket" {
  type        = string
  description = "Name of the bucket where you want Amazon S3 to store server access logs."
  default     = null
}

variable "bucket_logging_target_prefix" {
  type        = string
  description = "Prefix for all log object keys."
  default     = "logging"
}

variable "bucket_logging_target_grant" {
  type = list(
    object(
      {
        permission = string
        grantee = object(
          {
            email_address = optional(string)
            id            = optional(string)
            type          = string
            uri           = optional(string)
          }
        )
      }
    )
  )
  description = "Set of configuration blocks with information for granting permissions."
  default     = null
}

# BUCKET METRIC

variable "enable_bucket_metric" {
  type        = bool
  description = "Wheter to enable bucket metric"
  default     = false
}

variable "bucket_metric_name" {
  type        = string
  description = "Unique identifier of the metrics configuration for the bucket."
  default     = null
}

variable "bucket_metric_filter" {
  type = object(
    {
      prefix = optional(string)
      tags   = optional(map(string))
    }
  )
  description = "Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags"
  default     = null
}

# BUCKET NOTIFICATION

variable "enable_bucket_notification" {
  type        = bool
  description = "Whether to enable bucket notification"
  default     = false
}

variable "bucket_notification_event_bridge" {
  type        = bool
  description = "Whether to enable Amazon EventBridge notifications."
  default     = false
}

variable "bucket_notification_lambda_function" {
  type = list(
    object(
      {
        events              = list(string)
        filter_prefix       = optional(string)
        filter_suffix       = optional(string)
        id                  = optional(string)
        lambda_function_arn = string
      }
    )
  )
  description = "Used to configure notifications to a Lambda Function."
  default     = null
}

variable "bucket_notification_queue" {
  type = list(
    object(
      {
        events        = list(string)
        filter_prefix = optional(string)
        filter_suffix = optional(string)
        id            = optional(string)
        queue_arn     = string
      }
    )
  )
  description = "Notification configuration to SQS Queue."
  default     = null
}

variable "bucket_notification_topic" {
  type = list(
    object(
      {
        events        = list(string)
        filter_prefix = optional(string)
        filter_suffix = optional(string)
        id            = optional(string)
        topic_arn     = string
      }
    )
  )
  description = "Notification configuration to SNS Topic"
  default     = null
}

# BUCKET OBJECT LOCK CONFIGURATION

variable "enable_object_lock" {
  type        = bool
  description = "Whether to enable object lock"
  default     = false
}

variable "object_lock_token" {
  type        = string
  description = "Token to allow Object Lock to be enabled for an existing bucket."
  default     = null
}

variable "object_lock_rule" {
  type = object(
    {
      days  = optional(number)
      mode  = string
      years = optional(number)
    }
  )
  description = "Configuration block for specifying the Object Lock rule for the specified object"
  default     = null
}

# BUCKET OWNERSHIP CONTROLS

variable "enable_ownership_control" {
  type        = bool
  description = "Whether to eneble bucket ownership control"
  default     = false
}

variable "object_ownership" {
  type        = string
  description = "Ownership Control.Valid values: 'BucketOwnerPreferred', 'ObjectWriter' or 'BucketOwnerEnforced'"
  default     = null
}

# BUCKET POLICY

variable "create_bucket_policy" {
  type        = bool
  description = "Wheter to create bucket policy"
  default     = false
}

variable "bucket_policy_statements" {
  type = list(
    object(
      {
        sid    = optional(string)
        effect = optional(string)
        principals = optional(
          list(
            object(
              {
                principal_type        = string
                principal_identifiers = list(string)
              }
            )
          )
        )
        actions   = optional(list(string))
        resources = optional(list(string))
        condition = optional(
          list(
            object(
              {
                condition_test     = string
                condition_variable = string
                condition_values   = list(string)
              }
            )
          )
        )
      }
    )
  )
  description = "Text of the policy"
  default = [
    {
      actions    = []
      condition  = null
      effect     = null
      principals = null
      resources  = []
      sid        = null
    }
  ]
}

# BUCKET PUBLIC ACCESS BLOCK

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucke"
  default     = true
}

# BUCKET REQUEST PAYMENT CONFIGURATION 

variable "enable_request_payment" {
  type        = bool
  description = "Whether to eneble request payment configuration"
  default     = false
}

variable "request_payment_payer" {
  type        = string
  description = "Specifies who pays for the download and request fees. "
  default     = "Requester"
}

# BUCKET SERVER SIDE ENCRYPTION CONFIGURATION

variable "enable_server_side_encryption" {
  type        = bool
  description = "Whether to create server side encryption"
  default     = false
}

variable "server_side_encryption_rule" {
  type = list(
    object(
      {
        bucket_key_enabled = optional(bool)
        apply_server_side_encryption_by_default = optional(
          object(
            {
              sse_algorithm     = string
              kms_master_key_id = optional(string)
            }
          )
        )
      }
    )
  )
  description = "Set of server-side encryption configuration rules"
  default     = null
}

# BUCKET VERSIONING

variable "enable_bucket_versioning" {
  type        = bool
  description = "Whether to enable bucket versioning"
  default     = false
}

variable "versioning_configuration_status" {
  type        = string
  description = "Versioning state of the bucket."
  default     = "Enabled"
}

variable "versioning_configuration_mfa_delete" {
  type        = string
  description = "Specifies whether MFA delete is enabled in the bucket versioning configuration."
  default     = null
}

variable "bucket_versioning_mfa" {
  type        = string
  description = "Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device."
  default     = null
}

# BUCKET WEBSITE CONFIGURATION

variable "enable_static_website" {
  type        = bool
  description = "Whether to enable static website"
  default     = false
}

variable "static_website_error_document" {
  type = object(
    {
      key = string
    }
  )
  description = "Name of the error document for the website"
  default     = null
}

variable "static_website_index_document" {
  type = object(
    {
      suffix = string
    }
  )
  description = "Name of the index document for the website."
  default     = null
}

variable "static_website_redirect" {
  type = object(
    {
      host_name = string
      protocol  = optional(string)
    }
  )
  description = "Redirect behavior for every request to this bucket's website endpoint"
  default     = null
}

variable "static_website_routing_rule" {
  type = list(
    object(
      {
        condition = optional(
          object(
            {
              http_error_code_returned_equals = optional(string)
              key_prefix_equals               = optional(string)
            }
          )
        )
        redirect = object(
          {
            hostname                = optional(string)
            http_redirect_code      = optional(string)
            protocol                = optional(string)
            replace_key_prefix_with = optional(string)
            replace_key_with        = optional(string)
          }
        )
      }
    )
  )
  description = "List of rules that define when a redirect is applied and the redirect behavior"
  default     = null
}

variable "static_website_routing_rules" {
  type        = any
  description = "JSON array containing routing rules describing redirect behavior and when redirects are applied. Use this parameter when your routing rules contain empty String values"
  default     = null
}

# S3 OBJECT

variable "create_s3_object" {
  type        = bool
  description = "Whether to create a s3 bucket object"
  default     = false
}

variable "s3_object_key" {
  type        = string
  description = "Name of the object once it is in the bucket."
  default     = null
}

variable "s3_object_acl" {
  type        = string
  description = "Canned ACL to apply"
  default     = "private"
}

variable "s3_object_key_enabled" {
  type        = bool
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS."
  default     = false
}

variable "s3_object_content_base64" {
  type        = string
  description = "Base64-encoded data that will be decoded and uploaded as raw bytes for the object content."
  default     = null
}

variable "s3_object_content_disposition" {
  type        = string
  description = "Presentational information for the object."
  default     = null
}

variable "s3_object_content_encoding" {
  type        = string
  description = "Content encodings that have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field"
  default     = null
}

variable "s3_object_content_language" {
  type        = string
  description = "Language the content is in e.g., en-US or en-GB."
  default     = null
}

variable "s3_object_content_type" {
  type        = string
  description = "Standard MIME type describing the format of the object data, e.g., application/octet-stream"
  default     = null
}

variable "s3_object_content" {
  type        = string
  description = "Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text."
  default     = null
}

variable "s3_object_etag" {
  type        = string
  description = "Triggers updates when the value changes."
  default     = null
}

variable "s3_object_force_destroy" {
  type        = bool
  description = "Whether to allow the object to be deleted by removing any legal hold on any object version"
  default     = false
}

variable "s3_object_kms_key_id" {
  type        = string
  description = "ARN of the KMS Key to use for object encryption."
  default     = null
}

variable "s3_object_metadata" {
  type        = map(any)
  description = "Map of keys/values to provision metadata"
  default     = null
}

variable "s3_object_lock_legal_hold_status" {
  type        = string
  description = "Legal hold status that you want to apply to the specified object."
  default     = null
}

variable "s3_object_lock_mode" {
  type        = string
  description = "Object lock retention mode that you want to apply to this object."
  default     = null
}

variable "s3_object_lock_retain_until_date" {
  type        = string
  description = "Date and time, in RFC3339 format, when this object's object lock will expire"
  default     = null
}

variable "s3_object_server_side_encryption" {
  type        = string
  description = "Server-side encryption of the object in S3."
  default     = null
}

variable "s3_object_source" {
  type        = string
  description = "Path to a file that will be read and uploaded as raw bytes for the object content."
  default     = null
}

variable "s3_object_source_hash" {
  type        = string
  description = "Triggers updates like etag but useful to address etag encryption limitations. "
  default     = null
}

variable "s3_object_storage_class" {
  type        = string
  description = "Storage Class for the object"
  default     = "STANDARD"
}

variable "s3_object_website_redirect" {
  type        = string
  description = "Target URL for website redirect."
  default     = null
}

# S3 OBJECT COPY

variable "copy_s3_object" {
  type        = bool
  description = "Whether to copy any object to s3 bucket"
  default     = false
}

variable "copy_s3_object_key" {
  type        = string
  description = "Name of the object once it is in the bucket."
  default     = null
}

variable "copy_s3_object_source" {
  type        = string
  description = "Specifies the source object for the copy operation"
  default     = null
}

variable "copy_s3_object_acl" {
  type        = string
  description = "Canned ACL to apply."
  default     = "private"
}

variable "copy_s3_object_content_disposition" {
  type        = string
  description = "Specifies presentational information for the object."
  default     = null
}

variable "copy_s3_object_content_encoding" {
  type        = string
  description = "Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field."
  default     = null
}

variable "copy_s3_object_content_language" {
  type        = string
  description = "Language the content is in e.g., en-US or en-GB."
  default     = null
}

variable "copy_s3_object_content_type" {
  type        = string
  description = "Standard MIME type describing the format of the object data, e.g., application/octet-stream"
  default     = null
}

variable "copy_s3_object_copy_if_match" {
  type        = string
  description = "Copies the object if its entity tag (ETag) matches the specified tag."
  default     = null
}

variable "copy_s3_object_copy_if_none_match" {
  type        = string
  description = "Copies the object if its entity tag (ETag) is different than the specified ETag."
  default     = null
}

variable "copy_s3_object_copy_if_modified_since" {
  type        = string
  description = "Copies the object if it has been modified since the specified time, in RFC3339 format."
  default     = null
}

variable "copy_s3_object_copy_if_unmodified_since" {
  type        = string
  description = "Copies the object if it hasn't been modified since the specified time, in RFC3339 format."
  default     = null
}

variable "copy_s3_object_customer_algorithm" {
  type        = string
  description = "Specifies the algorithm to use to when encrypting the object"
  default     = null
}

variable "copy_s3_object_customer_key" {
  type        = string
  description = "Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data."
  default     = null
}

variable "copy_s3_object_customer_key_md5" {
  type        = string
  description = "Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321"
  default     = null
}

variable "copy_s3_object_expected_bucket_owner" {
  type        = string
  description = "Account id of the expected destination bucket owner."
  default     = null
}

variable "copy_s3_object_expected_source_bucket_owner" {
  type        = string
  description = "Account id of the expected source bucket owner"
  default     = null
}

variable "copy_s3_object_expires" {
  type        = string
  description = "Date and time at which the object is no longer cacheable, in RFC3339 format."
  default     = null
}

variable "copy_s3_object_force_destroy" {
  type        = bool
  description = "Allow the object to be deleted by removing any legal hold on any object version."
  default     = false
}

variable "copy_s3_object_kms_encryption_context" {
  type        = any
  description = "Specifies the AWS KMS Encryption Context to use for object encryption. "
  default     = null
}

variable "copy_s3_object_kms_key_id" {
  type        = string
  description = "Specifies the AWS KMS Key ARN to use for object encryption."
  default     = null
}

variable "copy_s3_object_metadata" {
  type        = map(any)
  description = "Map of keys/values to provision metadata"
  default     = null
}

variable "copy_s3_object_metadata_directive" {
  type        = string
  description = "Specifies whether the metadata is copied from the source object or replaced with metadata provided in the request."
  default     = "COPY"
}

variable "copy_s3_object_lock_legal_hold_status" {
  type        = string
  description = "The legal hold status that you want to apply to the specified object"
  default     = null
}

variable "copy_s3_object_lock_mode" {
  type        = string
  description = "Object lock retention mode that you want to apply to this object."
  default     = null
}

variable "copy_s3_object_lock_retain_until_date" {
  type        = string
  description = "Date and time, in RFC3339 format, when this object's object lock will expire."
  default     = null
}

variable "copy_s3_object_request_payer" {
  type        = any
  description = "Confirms that the requester knows that they will be charged for the request."
  default     = null
}

variable "copy_s3_object_server_side_encryption" {
  type        = string
  description = "Specifies server-side encryption of the object in S3."
  default     = null
}

variable "copy_s3_object_source_customer_algorithm" {
  type        = string
  description = "Specifies the algorithm to use when decrypting the source object"
  default     = null
}

variable "copy_s3_object_source_customer_key" {
  type        = string
  description = "Specifies the customer-provided encryption key for Amazon S3 to use to decrypt the source object"
  default     = null
}

variable "copy_s3_object_source_customer_key_md5" {
  type        = string
  description = "Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321."
  default     = null
}

variable "copy_s3_object_storage_class" {
  type        = string
  description = "Specifies the desired storage class for the object."
  default     = "STANDARD"
}

variable "copy_s3_object_tagging_directive" {
  type        = string
  description = "Specifies whether the object tag-set are copied from the source object or replaced with tag-set provided in the request."
  default     = "COPY"
}

variable "copy_s3_object_website_redirect" {
  type        = string
  description = "Specifies a target URL for website redirect."
  default     = null
}

variable "object_copy_grant" {
  type = object(
    {
      uri         = optional(string)
      type        = string
      permissions = list(string)
      email       = optional(string)
      id          = optional(string)
    }
  )
  description = " Configuration block for header grants. Documented below. "
  default     = null
}