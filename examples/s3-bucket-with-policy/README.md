## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.20.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3"></a> [s3](#module\_s3) | ../../ | n/a |

## Description

This is an example Terraform script for Create S3 bucket with Bucket Policy.

## Example

```
  module "s3" {
    source = "../../"

    s3_bucket_name       = "terraform-test-123456789"
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

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_bucket_policy"></a> [create\_bucket\_policy](#input\_create\_bucket\_policy) | Wheter to create bucket policy | `bool` | `true` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the pipeline s3 bucket. | `string` | `null` | no |

## Outputs

No outputs.
