## Introduction

This Terraform module is for ***AWS S3 (Simple Storage Service)*** and provides a powerful and efficient way to manage object storage within the Amazon Web Services (AWS) ecosystem.

AWS S3 is a scalable and highly durable storage service that enables you to store and retrieve large amounts of data, such as files, documents, images, and backups. With the Terraform module for AWS S3, you can automate the configuration and deployment of S3 buckets, policies, and other settings, simplifying the management of your object storage infrastructure.

This Terraform module offers a reusable and configurable approach to creating and managing S3 resources. It abstracts away the complexities of manually provisioning S3 buckets and configuring permissions, allowing you to define them as code and apply changes efficiently.

Using this Terraform module, you can define S3 buckets, set access policies, enable versioning and encryption, configure lifecycle rules, and manage other S3 features and settings. This module provides a comprehensive set of configurable parameters, enabling you to customize S3 resources based on your specific requirements.

Additionally, by managing S3 resources as code, you can easily version control and track changes to your S3 configurations, apply them in a controlled manner, and maintain an auditable history of your object storage infrastructure.

## Usage

### Example code for S3 bucket with bucket policy for AWS Code Pipeline.

```
  module "s3" {
    source = "jerinrathnam/s3/aws"

    s3_bucket_name       = var.bucket_name
    create_bucket_policy = true

    bucket_policy_statements = [
      {
        actions = ["s3:PutObject"]
        condition = [
          {
            condition_test     = "StringNotEquals"
            condition_values   = ["aws:kms"]
            condition_variable = "s3:x-amz-server-side-encryption"
          }
        ]
        effect = "Deny"
        principals = [
          {
            principal_type        = "AWS"
            principal_identifiers = ["*"]
          }
        ]
        resources = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*"
        ]
        sid = "S3BucketPutObject"
      },
      {
        actions = ["s3:*"]
        condition = [
          {
            condition_test     = "Bool"
            condition_values   = ["false"]
            condition_variable = "aws:SecureTransport"
          }
        ]
        effect = "Deny"
        principals = [
          {
            principal_type        = "AWS"
            principal_identifiers = ["*"]
          }
        ]
        resources = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*"
        ]
        sid = "S3BucketFullAccess"
      }
    ]
  }
```

## Example

- [S3 Bucket Lifecycle Configuration](https://github.com/jerinrathnam/terraform-aws-s3/tree/master/examples/bucket-lifecycle-configuration)
- [S3 Bucket Notification with SNS](https://github.com/jerinrathnam/terraform-aws-s3/tree/master/examples/bucket-notification-sns)
- [S3 Bucket with bucket Policy](https://github.com/jerinrathnam/terraform-aws-s3/tree/master/examples/s3-bucket-with-policy)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.59.0 |

## Description 

This module will create an S3 bucket with all other S3 bucket settings like Bucket ACL, Bucket Lifecycle, Bucket Policy, Bucket Website, etc...

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_analytics_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_analytics_configuration) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_inventory.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_metric.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_request_payment_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object_copy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object_copy) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_control_policy"></a> [access\_control\_policy](#input\_access\_control\_policy) | Configuration block that sets the ACL permissions for an object per grantee. | <pre>object(<br>    {<br>      grant = object(<br>        {<br>          grantee = object(<br>            {<br>              email_address = optional(string)<br>              id            = optional(string)<br>              type          = string<br>              uri           = optional(string)<br>            }<br>          )<br>          permission = string<br>        }<br>      )<br>      owner = object(<br>        {<br>          id           = string<br>          display_name = optional(string)<br>        }<br>      )<br>    }<br>  )</pre> | `null` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_bucket_acl"></a> [bucket\_acl](#input\_bucket\_acl) | Canned ACL to apply to the bucket. | `string` | `null` | no |
| <a name="input_bucket_analytics_configuration_filter"></a> [bucket\_analytics\_configuration\_filter](#input\_bucket\_analytics\_configuration\_filter) | Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags | <pre>object(<br>    {<br>      prefix = optional(string)<br>      tags = optional(<br>        map(any)<br>      )<br>    }<br>  )</pre> | `null` | no |
| <a name="input_bucket_analytics_configuration_name"></a> [bucket\_analytics\_configuration\_name](#input\_bucket\_analytics\_configuration\_name) | Unique identifier of the analytics configuration for the bucket. | `string` | `null` | no |
| <a name="input_bucket_intelligent_tiering_block"></a> [bucket\_intelligent\_tiering\_block](#input\_bucket\_intelligent\_tiering\_block) | S3 Intelligent-Tiering storage class tiers of the configuration | <pre>list(<br>    object(<br>      {<br>        access_tier = string<br>        days        = number<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_bucket_intelligent_tiering_filter"></a> [bucket\_intelligent\_tiering\_filter](#input\_bucket\_intelligent\_tiering\_filter) | Bucket filter. The configuration only includes objects that meet the filter's criteria | <pre>object(<br>    {<br>      prefix = optional(string)<br>      tags   = optional(map(string))<br>    }<br>  )</pre> | `null` | no |
| <a name="input_bucket_intelligent_tiering_name"></a> [bucket\_intelligent\_tiering\_name](#input\_bucket\_intelligent\_tiering\_name) | Unique name used to identify the S3 Intelligent-Tiering configuration for the bucket. | `string` | `null` | no |
| <a name="input_bucket_intelligent_tiering_status"></a> [bucket\_intelligent\_tiering\_status](#input\_bucket\_intelligent\_tiering\_status) | Specifies the status of the configuration. | `string` | `null` | no |
| <a name="input_bucket_logging_target_bucket"></a> [bucket\_logging\_target\_bucket](#input\_bucket\_logging\_target\_bucket) | Name of the bucket where you want Amazon S3 to store server access logs. | `string` | `null` | no |
| <a name="input_bucket_logging_target_grant"></a> [bucket\_logging\_target\_grant](#input\_bucket\_logging\_target\_grant) | Set of configuration blocks with information for granting permissions. | <pre>list(<br>    object(<br>      {<br>        permission = string<br>        grantee = object(<br>          {<br>            email_address = optional(string)<br>            id            = optional(string)<br>            type          = string<br>            uri           = optional(string)<br>          }<br>        )<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_bucket_logging_target_prefix"></a> [bucket\_logging\_target\_prefix](#input\_bucket\_logging\_target\_prefix) | Prefix for all log object keys. | `string` | `"logging"` | no |
| <a name="input_bucket_metric_filter"></a> [bucket\_metric\_filter](#input\_bucket\_metric\_filter) | Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags | <pre>object(<br>    {<br>      prefix = optional(string)<br>      tags   = optional(map(string))<br>    }<br>  )</pre> | `null` | no |
| <a name="input_bucket_metric_name"></a> [bucket\_metric\_name](#input\_bucket\_metric\_name) | Unique identifier of the metrics configuration for the bucket. | `string` | `null` | no |
| <a name="input_bucket_notification_event_bridge"></a> [bucket\_notification\_event\_bridge](#input\_bucket\_notification\_event\_bridge) | Whether to enable Amazon EventBridge notifications. | `bool` | `false` | no |
| <a name="input_bucket_notification_lambda_function"></a> [bucket\_notification\_lambda\_function](#input\_bucket\_notification\_lambda\_function) | Used to configure notifications to a Lambda Function. | <pre>list(<br>    object(<br>      {<br>        events              = list(string)<br>        filter_prefix       = optional(string)<br>        filter_suffix       = optional(string)<br>        id                  = optional(string)<br>        lambda_function_arn = string<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_bucket_notification_queue"></a> [bucket\_notification\_queue](#input\_bucket\_notification\_queue) | Notification configuration to SQS Queue. | <pre>list(<br>    object(<br>      {<br>        events        = list(string)<br>        filter_prefix = optional(string)<br>        filter_suffix = optional(string)<br>        id            = optional(string)<br>        queue_arn     = string<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_bucket_notification_topic"></a> [bucket\_notification\_topic](#input\_bucket\_notification\_topic) | Notification configuration to SNS Topic | <pre>list(<br>    object(<br>      {<br>        events        = list(string)<br>        filter_prefix = optional(string)<br>        filter_suffix = optional(string)<br>        id            = optional(string)<br>        topic_arn     = string<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_bucket_policy_statements"></a> [bucket\_policy\_statements](#input\_bucket\_policy\_statements) | Text of the policy | <pre>list(<br>    object(<br>      {<br>        sid    = optional(string)<br>        effect = optional(string)<br>        principals = optional(<br>          list(<br>            object(<br>              {<br>                principal_type        = string<br>                principal_identifiers = list(string)<br>              }<br>            )<br>          )<br>        )<br>        actions   = optional(list(string))<br>        resources = optional(list(string))<br>        condition = optional(<br>          list(<br>            object(<br>              {<br>                condition_test     = string<br>                condition_variable = string<br>                condition_values   = list(string)<br>              }<br>            )<br>          )<br>        )<br>      }<br>    )<br>  )</pre> | <pre>[<br>  {<br>    "actions": [],<br>    "condition": null,<br>    "effect": null,<br>    "principals": null,<br>    "resources": [],<br>    "sid": null<br>  }<br>]</pre> | no |
| <a name="input_bucket_versioning_mfa"></a> [bucket\_versioning\_mfa](#input\_bucket\_versioning\_mfa) | Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. | `string` | `null` | no |
| <a name="input_copy_s3_object"></a> [copy\_s3\_object](#input\_copy\_s3\_object) | Whether to copy any object to s3 bucket | `bool` | `false` | no |
| <a name="input_copy_s3_object_acl"></a> [copy\_s3\_object\_acl](#input\_copy\_s3\_object\_acl) | Canned ACL to apply. | `string` | `"private"` | no |
| <a name="input_copy_s3_object_content_disposition"></a> [copy\_s3\_object\_content\_disposition](#input\_copy\_s3\_object\_content\_disposition) | Specifies presentational information for the object. | `string` | `null` | no |
| <a name="input_copy_s3_object_content_encoding"></a> [copy\_s3\_object\_content\_encoding](#input\_copy\_s3\_object\_content\_encoding) | Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field. | `string` | `null` | no |
| <a name="input_copy_s3_object_content_language"></a> [copy\_s3\_object\_content\_language](#input\_copy\_s3\_object\_content\_language) | Language the content is in e.g., en-US or en-GB. | `string` | `null` | no |
| <a name="input_copy_s3_object_content_type"></a> [copy\_s3\_object\_content\_type](#input\_copy\_s3\_object\_content\_type) | Standard MIME type describing the format of the object data, e.g., application/octet-stream | `string` | `null` | no |
| <a name="input_copy_s3_object_copy_if_match"></a> [copy\_s3\_object\_copy\_if\_match](#input\_copy\_s3\_object\_copy\_if\_match) | Copies the object if its entity tag (ETag) matches the specified tag. | `string` | `null` | no |
| <a name="input_copy_s3_object_copy_if_modified_since"></a> [copy\_s3\_object\_copy\_if\_modified\_since](#input\_copy\_s3\_object\_copy\_if\_modified\_since) | Copies the object if it has been modified since the specified time, in RFC3339 format. | `string` | `null` | no |
| <a name="input_copy_s3_object_copy_if_none_match"></a> [copy\_s3\_object\_copy\_if\_none\_match](#input\_copy\_s3\_object\_copy\_if\_none\_match) | Copies the object if its entity tag (ETag) is different than the specified ETag. | `string` | `null` | no |
| <a name="input_copy_s3_object_copy_if_unmodified_since"></a> [copy\_s3\_object\_copy\_if\_unmodified\_since](#input\_copy\_s3\_object\_copy\_if\_unmodified\_since) | Copies the object if it hasn't been modified since the specified time, in RFC3339 format. | `string` | `null` | no |
| <a name="input_copy_s3_object_customer_algorithm"></a> [copy\_s3\_object\_customer\_algorithm](#input\_copy\_s3\_object\_customer\_algorithm) | Specifies the algorithm to use to when encrypting the object | `string` | `null` | no |
| <a name="input_copy_s3_object_customer_key"></a> [copy\_s3\_object\_customer\_key](#input\_copy\_s3\_object\_customer\_key) | Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. | `string` | `null` | no |
| <a name="input_copy_s3_object_customer_key_md5"></a> [copy\_s3\_object\_customer\_key\_md5](#input\_copy\_s3\_object\_customer\_key\_md5) | Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321 | `string` | `null` | no |
| <a name="input_copy_s3_object_expected_bucket_owner"></a> [copy\_s3\_object\_expected\_bucket\_owner](#input\_copy\_s3\_object\_expected\_bucket\_owner) | Account id of the expected destination bucket owner. | `string` | `null` | no |
| <a name="input_copy_s3_object_expected_source_bucket_owner"></a> [copy\_s3\_object\_expected\_source\_bucket\_owner](#input\_copy\_s3\_object\_expected\_source\_bucket\_owner) | Account id of the expected source bucket owner | `string` | `null` | no |
| <a name="input_copy_s3_object_expires"></a> [copy\_s3\_object\_expires](#input\_copy\_s3\_object\_expires) | Date and time at which the object is no longer cacheable, in RFC3339 format. | `string` | `null` | no |
| <a name="input_copy_s3_object_force_destroy"></a> [copy\_s3\_object\_force\_destroy](#input\_copy\_s3\_object\_force\_destroy) | Allow the object to be deleted by removing any legal hold on any object version. | `bool` | `false` | no |
| <a name="input_copy_s3_object_key"></a> [copy\_s3\_object\_key](#input\_copy\_s3\_object\_key) | Name of the object once it is in the bucket. | `string` | `null` | no |
| <a name="input_copy_s3_object_kms_encryption_context"></a> [copy\_s3\_object\_kms\_encryption\_context](#input\_copy\_s3\_object\_kms\_encryption\_context) | Specifies the AWS KMS Encryption Context to use for object encryption. | `any` | `null` | no |
| <a name="input_copy_s3_object_kms_key_id"></a> [copy\_s3\_object\_kms\_key\_id](#input\_copy\_s3\_object\_kms\_key\_id) | Specifies the AWS KMS Key ARN to use for object encryption. | `string` | `null` | no |
| <a name="input_copy_s3_object_lock_legal_hold_status"></a> [copy\_s3\_object\_lock\_legal\_hold\_status](#input\_copy\_s3\_object\_lock\_legal\_hold\_status) | The legal hold status that you want to apply to the specified object | `string` | `null` | no |
| <a name="input_copy_s3_object_lock_mode"></a> [copy\_s3\_object\_lock\_mode](#input\_copy\_s3\_object\_lock\_mode) | Object lock retention mode that you want to apply to this object. | `string` | `null` | no |
| <a name="input_copy_s3_object_lock_retain_until_date"></a> [copy\_s3\_object\_lock\_retain\_until\_date](#input\_copy\_s3\_object\_lock\_retain\_until\_date) | Date and time, in RFC3339 format, when this object's object lock will expire. | `string` | `null` | no |
| <a name="input_copy_s3_object_metadata"></a> [copy\_s3\_object\_metadata](#input\_copy\_s3\_object\_metadata) | Map of keys/values to provision metadata | `map(any)` | `null` | no |
| <a name="input_copy_s3_object_metadata_directive"></a> [copy\_s3\_object\_metadata\_directive](#input\_copy\_s3\_object\_metadata\_directive) | Specifies whether the metadata is copied from the source object or replaced with metadata provided in the request. | `string` | `"COPY"` | no |
| <a name="input_copy_s3_object_request_payer"></a> [copy\_s3\_object\_request\_payer](#input\_copy\_s3\_object\_request\_payer) | Confirms that the requester knows that they will be charged for the request. | `any` | `null` | no |
| <a name="input_copy_s3_object_server_side_encryption"></a> [copy\_s3\_object\_server\_side\_encryption](#input\_copy\_s3\_object\_server\_side\_encryption) | Specifies server-side encryption of the object in S3. | `string` | `null` | no |
| <a name="input_copy_s3_object_source"></a> [copy\_s3\_object\_source](#input\_copy\_s3\_object\_source) | Specifies the source object for the copy operation | `string` | `null` | no |
| <a name="input_copy_s3_object_source_customer_algorithm"></a> [copy\_s3\_object\_source\_customer\_algorithm](#input\_copy\_s3\_object\_source\_customer\_algorithm) | Specifies the algorithm to use when decrypting the source object | `string` | `null` | no |
| <a name="input_copy_s3_object_source_customer_key"></a> [copy\_s3\_object\_source\_customer\_key](#input\_copy\_s3\_object\_source\_customer\_key) | Specifies the customer-provided encryption key for Amazon S3 to use to decrypt the source object | `string` | `null` | no |
| <a name="input_copy_s3_object_source_customer_key_md5"></a> [copy\_s3\_object\_source\_customer\_key\_md5](#input\_copy\_s3\_object\_source\_customer\_key\_md5) | Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. | `string` | `null` | no |
| <a name="input_copy_s3_object_storage_class"></a> [copy\_s3\_object\_storage\_class](#input\_copy\_s3\_object\_storage\_class) | Specifies the desired storage class for the object. | `string` | `"STANDARD"` | no |
| <a name="input_copy_s3_object_tagging_directive"></a> [copy\_s3\_object\_tagging\_directive](#input\_copy\_s3\_object\_tagging\_directive) | Specifies whether the object tag-set are copied from the source object or replaced with tag-set provided in the request. | `string` | `"COPY"` | no |
| <a name="input_copy_s3_object_website_redirect"></a> [copy\_s3\_object\_website\_redirect](#input\_copy\_s3\_object\_website\_redirect) | Specifies a target URL for website redirect. | `string` | `null` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | Set of origins and methods (cross-origin access that you want to allow) | <pre>list(<br>    object(<br>      {<br>        id              = optional(string)<br>        allowed_methods = list(string)<br>        allowed_origins = list(string)<br>        allowed_headers = optional(list(string))<br>        expose_headers  = optional(list(string))<br>        max_age_seconds = optional(number)<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_create_bucket_policy"></a> [create\_bucket\_policy](#input\_create\_bucket\_policy) | Wheter to create bucket policy | `bool` | `false` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whehter the S3 bucket for codepipeline should be create | `bool` | `true` | no |
| <a name="input_create_s3_object"></a> [create\_s3\_object](#input\_create\_s3\_object) | Whether to create a s3 bucket object | `bool` | `false` | no |
| <a name="input_enable_bucket_accelerate"></a> [enable\_bucket\_accelerate](#input\_enable\_bucket\_accelerate) | Whether S3 bucket acceleration should be enabled | `bool` | `false` | no |
| <a name="input_enable_bucket_analytics_configuration"></a> [enable\_bucket\_analytics\_configuration](#input\_enable\_bucket\_analytics\_configuration) | Whether the bucket analytics configuration should be enabled | `bool` | `false` | no |
| <a name="input_enable_bucket_intelligent_tiering"></a> [enable\_bucket\_intelligent\_tiering](#input\_enable\_bucket\_intelligent\_tiering) | Whether the bucket intelligent tiering should be enabled | `bool` | `false` | no |
| <a name="input_enable_bucket_logging"></a> [enable\_bucket\_logging](#input\_enable\_bucket\_logging) | Whether to enable bucket logging | `bool` | `false` | no |
| <a name="input_enable_bucket_metric"></a> [enable\_bucket\_metric](#input\_enable\_bucket\_metric) | Wheter to enable bucket metric | `bool` | `false` | no |
| <a name="input_enable_bucket_notification"></a> [enable\_bucket\_notification](#input\_enable\_bucket\_notification) | Whether to enable bucket notification | `bool` | `false` | no |
| <a name="input_enable_bucket_versioning"></a> [enable\_bucket\_versioning](#input\_enable\_bucket\_versioning) | Whether to enable bucket versioning | `bool` | `false` | no |
| <a name="input_enable_cors_configuration"></a> [enable\_cors\_configuration](#input\_enable\_cors\_configuration) | Whether the CORS configuration should be enable | `bool` | `false` | no |
| <a name="input_enable_lifecycle_configuration"></a> [enable\_lifecycle\_configuration](#input\_enable\_lifecycle\_configuration) | Whether to enable bucket lifecycle configuration | `bool` | `false` | no |
| <a name="input_enable_object_lock"></a> [enable\_object\_lock](#input\_enable\_object\_lock) | Whether to enable object lock | `bool` | `false` | no |
| <a name="input_enable_ownership_control"></a> [enable\_ownership\_control](#input\_enable\_ownership\_control) | Whether to eneble bucket ownership control | `bool` | `false` | no |
| <a name="input_enable_request_payment"></a> [enable\_request\_payment](#input\_enable\_request\_payment) | Whether to eneble request payment configuration | `bool` | `false` | no |
| <a name="input_enable_s3_bucket_inventory"></a> [enable\_s3\_bucket\_inventory](#input\_enable\_s3\_bucket\_inventory) | Whether the bucket inventory should be enabled | `bool` | `false` | no |
| <a name="input_enable_server_side_encryption"></a> [enable\_server\_side\_encryption](#input\_enable\_server\_side\_encryption) | Whether to create server side encryption | `bool` | `false` | no |
| <a name="input_enable_static_website"></a> [enable\_static\_website](#input\_enable\_static\_website) | Whether to enable static website | `bool` | `false` | no |
| <a name="input_expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | Account ID of the expected bucket owner. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket | `bool` | `true` | no |
| <a name="input_included_object_versions"></a> [included\_object\_versions](#input\_included\_object\_versions) | Object versions to include in the inventory list. | `string` | `"All"` | no |
| <a name="input_lifecycle_configuration_rule"></a> [lifecycle\_configuration\_rule](#input\_lifecycle\_configuration\_rule) | List of configuration blocks describing the rules managing the replication | <pre>list(<br>    object(<br>      {<br>        abort_incomplete_multipart_upload = optional(<br>          object(<br>            {<br>              days_after_initiation = number<br>            }<br>          )<br>        )<br>        expiration = optional(<br>          object(<br>            {<br>              date                         = optional(string)<br>              days                         = optional(number)<br>              expired_object_delete_marker = optional(bool)<br>            }<br>          )<br>        )<br>        filter = optional(<br>          object(<br>            {<br>              prefix                   = optional(string)<br>              object_size_greater_than = optional(number)<br>              object_size_less_than    = optional(number)<br>              tag                      = optional(map(string))<br>              and = optional(<br>                object(<br>                  {<br>                    prefix                   = optional(string)<br>                    object_size_greater_than = optional(number)<br>                    object_size_less_than    = optional(number)<br>                    tags = optional(<br>                      map(string)<br>                    )<br>                  }<br>                )<br>              )<br>            }<br>          )<br>        )<br>        id = string<br>        noncurrent_version_expiration = optional(<br>          object(<br>            {<br>              newer_noncurrent_version = optional(number)<br>              noncurrent_days          = optional(number)<br>            }<br>          )<br>        )<br>        noncurrent_version_transition = optional(<br>          list(<br>            object(<br>              {<br>                storage_class            = string<br>                newer_noncurrent_version = optional(number)<br>                noncurrent_days          = optional(number)<br>              }<br>            )<br>          )<br>        )<br>        status = string<br>        transition = optional(<br>          list(<br>            object(<br>              {<br>                date          = optional(string)<br>                days          = optional(number)<br>                storage_class = optional(string)<br>              }<br>            )<br>          )<br>        )<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for this infrastructure | `string` | `null` | no |
| <a name="input_object_copy_grant"></a> [object\_copy\_grant](#input\_object\_copy\_grant) | Configuration block for header grants. Documented below. | <pre>object(<br>    {<br>      uri         = optional(string)<br>      type        = string<br>      permissions = list(string)<br>      email       = optional(string)<br>      id          = optional(string)<br>    }<br>  )</pre> | `null` | no |
| <a name="input_object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | Indicates whether this bucket has an Object Lock configuration enabled. | `bool` | `false` | no |
| <a name="input_object_lock_rule"></a> [object\_lock\_rule](#input\_object\_lock\_rule) | Configuration block for specifying the Object Lock rule for the specified object | <pre>object(<br>    {<br>      days  = optional(number)<br>      mode  = string<br>      years = optional(number)<br>    }<br>  )</pre> | `null` | no |
| <a name="input_object_lock_token"></a> [object\_lock\_token](#input\_object\_lock\_token) | Token to allow Object Lock to be enabled for an existing bucket. | `string` | `null` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Ownership Control.Valid values: 'BucketOwnerPreferred', 'ObjectWriter' or 'BucketOwnerEnforced' | `string` | `null` | no |
| <a name="input_request_payment_payer"></a> [request\_payment\_payer](#input\_request\_payment\_payer) | Specifies who pays for the download and request fees. | `string` | `"Requester"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucke | `bool` | `true` | no |
| <a name="input_s3_bucket_inventory_destination"></a> [s3\_bucket\_inventory\_destination](#input\_s3\_bucket\_inventory\_destination) | Contains information about where to publish the inventory results | <pre>object(<br>    {<br>      format     = string<br>      bucket_arn = string<br>      prefix     = optional(string)<br>      account_id = optional(string)<br>      encryption = optional(<br>        object(<br>          {<br>            sse_s3 = optional(any)<br>            sse_kms = optional(<br>              object(<br>                {<br>                  key_id = optional(string)<br>                }<br>              )<br>            )<br>          }<br>        )<br>      )<br>    }<br>  )</pre> | `null` | no |
| <a name="input_s3_bucket_inventory_enabled"></a> [s3\_bucket\_inventory\_enabled](#input\_s3\_bucket\_inventory\_enabled) | Specifies whether the inventory is enabled or disabled. | `bool` | `true` | no |
| <a name="input_s3_bucket_inventory_filter"></a> [s3\_bucket\_inventory\_filter](#input\_s3\_bucket\_inventory\_filter) | Prefix that an object must have to be included in the inventory results. | <pre>object(<br>    {<br>      prefix = string<br>    }<br>  )</pre> | `null` | no |
| <a name="input_s3_bucket_inventory_frequency"></a> [s3\_bucket\_inventory\_frequency](#input\_s3\_bucket\_inventory\_frequency) | Specifies how frequently inventory results are produced. | `string` | `"Daily"` | no |
| <a name="input_s3_bucket_inventory_name"></a> [s3\_bucket\_inventory\_name](#input\_s3\_bucket\_inventory\_name) | Unique identifier of the inventory configuration for the bucket. | `string` | `null` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the pipeline s3 bucket. | `string` | `null` | no |
| <a name="input_s3_object_acl"></a> [s3\_object\_acl](#input\_s3\_object\_acl) | Canned ACL to apply | `string` | `"private"` | no |
| <a name="input_s3_object_content"></a> [s3\_object\_content](#input\_s3\_object\_content) | Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. | `string` | `null` | no |
| <a name="input_s3_object_content_base64"></a> [s3\_object\_content\_base64](#input\_s3\_object\_content\_base64) | Base64-encoded data that will be decoded and uploaded as raw bytes for the object content. | `string` | `null` | no |
| <a name="input_s3_object_content_disposition"></a> [s3\_object\_content\_disposition](#input\_s3\_object\_content\_disposition) | Presentational information for the object. | `string` | `null` | no |
| <a name="input_s3_object_content_encoding"></a> [s3\_object\_content\_encoding](#input\_s3\_object\_content\_encoding) | Content encodings that have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field | `string` | `null` | no |
| <a name="input_s3_object_content_language"></a> [s3\_object\_content\_language](#input\_s3\_object\_content\_language) | Language the content is in e.g., en-US or en-GB. | `string` | `null` | no |
| <a name="input_s3_object_content_type"></a> [s3\_object\_content\_type](#input\_s3\_object\_content\_type) | Standard MIME type describing the format of the object data, e.g., application/octet-stream | `string` | `null` | no |
| <a name="input_s3_object_etag"></a> [s3\_object\_etag](#input\_s3\_object\_etag) | Triggers updates when the value changes. | `string` | `null` | no |
| <a name="input_s3_object_force_destroy"></a> [s3\_object\_force\_destroy](#input\_s3\_object\_force\_destroy) | Whether to allow the object to be deleted by removing any legal hold on any object version | `bool` | `false` | no |
| <a name="input_s3_object_key"></a> [s3\_object\_key](#input\_s3\_object\_key) | Name of the object once it is in the bucket. | `string` | `null` | no |
| <a name="input_s3_object_key_enabled"></a> [s3\_object\_key\_enabled](#input\_s3\_object\_key\_enabled) | Whether or not to use Amazon S3 Bucket Keys for SSE-KMS. | `bool` | `false` | no |
| <a name="input_s3_object_kms_key_id"></a> [s3\_object\_kms\_key\_id](#input\_s3\_object\_kms\_key\_id) | ARN of the KMS Key to use for object encryption. | `string` | `null` | no |
| <a name="input_s3_object_lock_legal_hold_status"></a> [s3\_object\_lock\_legal\_hold\_status](#input\_s3\_object\_lock\_legal\_hold\_status) | Legal hold status that you want to apply to the specified object. | `string` | `null` | no |
| <a name="input_s3_object_lock_mode"></a> [s3\_object\_lock\_mode](#input\_s3\_object\_lock\_mode) | Object lock retention mode that you want to apply to this object. | `string` | `null` | no |
| <a name="input_s3_object_lock_retain_until_date"></a> [s3\_object\_lock\_retain\_until\_date](#input\_s3\_object\_lock\_retain\_until\_date) | Date and time, in RFC3339 format, when this object's object lock will expire | `string` | `null` | no |
| <a name="input_s3_object_metadata"></a> [s3\_object\_metadata](#input\_s3\_object\_metadata) | Map of keys/values to provision metadata | `map(any)` | `null` | no |
| <a name="input_s3_object_server_side_encryption"></a> [s3\_object\_server\_side\_encryption](#input\_s3\_object\_server\_side\_encryption) | Server-side encryption of the object in S3. | `string` | `null` | no |
| <a name="input_s3_object_source"></a> [s3\_object\_source](#input\_s3\_object\_source) | Path to a file that will be read and uploaded as raw bytes for the object content. | `string` | `null` | no |
| <a name="input_s3_object_source_hash"></a> [s3\_object\_source\_hash](#input\_s3\_object\_source\_hash) | Triggers updates like etag but useful to address etag encryption limitations. | `string` | `null` | no |
| <a name="input_s3_object_storage_class"></a> [s3\_object\_storage\_class](#input\_s3\_object\_storage\_class) | Storage Class for the object | `string` | `"STANDARD"` | no |
| <a name="input_s3_object_website_redirect"></a> [s3\_object\_website\_redirect](#input\_s3\_object\_website\_redirect) | Target URL for website redirect. | `string` | `null` | no |
| <a name="input_server_side_encryption_rule"></a> [server\_side\_encryption\_rule](#input\_server\_side\_encryption\_rule) | Set of server-side encryption configuration rules | <pre>list(<br>    object(<br>      {<br>        bucket_key_enabled = optional(bool)<br>        apply_server_side_encryption_by_default = optional(<br>          object(<br>            {<br>              sse_algorithm     = string<br>              kms_master_key_id = optional(string)<br>            }<br>          )<br>        )<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_static_website_error_document"></a> [static\_website\_error\_document](#input\_static\_website\_error\_document) | Name of the error document for the website | <pre>object(<br>    {<br>      key = string<br>    }<br>  )</pre> | `null` | no |
| <a name="input_static_website_index_document"></a> [static\_website\_index\_document](#input\_static\_website\_index\_document) | Name of the index document for the website. | <pre>object(<br>    {<br>      suffix = string<br>    }<br>  )</pre> | `null` | no |
| <a name="input_static_website_redirect"></a> [static\_website\_redirect](#input\_static\_website\_redirect) | Redirect behavior for every request to this bucket's website endpoint | <pre>object(<br>    {<br>      host_name = string<br>      protocol  = optional(string)<br>    }<br>  )</pre> | `null` | no |
| <a name="input_static_website_routing_rule"></a> [static\_website\_routing\_rule](#input\_static\_website\_routing\_rule) | List of rules that define when a redirect is applied and the redirect behavior | <pre>list(<br>    object(<br>      {<br>        condition = optional(<br>          object(<br>            {<br>              http_error_code_returned_equals = optional(string)<br>              key_prefix_equals               = optional(string)<br>            }<br>          )<br>        )<br>        redirect = object(<br>          {<br>            hostname                = optional(string)<br>            http_redirect_code      = optional(string)<br>            protocol                = optional(string)<br>            replace_key_prefix_with = optional(string)<br>            replace_key_with        = optional(string)<br>          }<br>        )<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_static_website_routing_rules"></a> [static\_website\_routing\_rules](#input\_static\_website\_routing\_rules) | JSON array containing routing rules describing redirect behavior and when redirects are applied. Use this parameter when your routing rules contain empty String values | `any` | `null` | no |
| <a name="input_storage_class_analysis"></a> [storage\_class\_analysis](#input\_storage\_class\_analysis) | Configuration for the analytics data export | <pre>object(<br>    {<br>      data_export_destination = object(<br>        {<br>          bucket_arn        = string<br>          bucket_account_id = optional(string)<br>          format            = optional(string)<br>          prefix            = optional(string)<br>        }<br>      )<br>    }<br>  )</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for this bucket | `map(string)` | `null` | no |
| <a name="input_versioning_configuration_mfa_delete"></a> [versioning\_configuration\_mfa\_delete](#input\_versioning\_configuration\_mfa\_delete) | Specifies whether MFA delete is enabled in the bucket versioning configuration. | `string` | `null` | no |
| <a name="input_versioning_configuration_status"></a> [versioning\_configuration\_status](#input\_versioning\_configuration\_status) | Versioning state of the bucket. | `string` | `"Enabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the S3 bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Domain name of this S3 bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the S3 bucket |
| <a name="output_website_domain"></a> [website\_domain](#output\_website\_domain) | Domain of the website endpoint. This is used to create Route 53 alias records. |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | Website endpoint of the S3 bucket |


## Authors

Module is maintained by [Jerin Rathnam](https://github.com/jerinrathnam).

**LinkedIn:**  _[Jerin Rathnam](https://www.linkedin.com/in/jerin-rathnam)_.

## License
Apache 2 Licensed. See [LICENSE](https://github.com/jerinrathnam/terraform-aws-s3/blob/master/LICENSE) for full details.