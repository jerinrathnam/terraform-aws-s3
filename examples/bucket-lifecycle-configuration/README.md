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

This is an example Terraform script for Create S3 bucket with Bucket Life Cycle Configuration.

## Example

```
  module "s3" {
    source = "../../"

    s3_bucket_name                 = "terraform-bucket-123456789"
    enable_lifecycle_configuration = true

    lifecycle_configuration_rule = [
      {
        abort_incomplete_multipart_upload = {
          days_after_initiation = 90
        }
      expiration = {
        days = 60
      }
      transition = [
        {
          days = 30
          storage_class = "ONEZONE_IA"
        },
        {
          days = 90
          storage_class = "GLACIER"
        }
      ]
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
