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
| <a name="module_s3-notification"></a> [s3-notification](#module\_s3-notification) | ../../ | n/a |

## Description

This is an example Terraform script for Create S3 bucket with Bucket Life Cycle Configuration.

## Example

```
  module "s3-notification" {
    source = "../../"

    s3_bucket_name             = "terraform-test-123456789"
    enable_bucket_notification = true
    bucket_notification_topic = [
      {
        events = [
          "s3:ObjectCreated:Put",
          "s3:ObjectCreated:Post",
          "s3:ObjectCreated:Copy",
          "s3:ObjectCreated:CompleteMultipartUpload",
          "s3:ObjectRemoved:Delete",
          "s3:ObjectRemoved:DeleteMarkerCreated",
          "s3:ObjectRestore:Post",
          "s3:ObjectRestore:Completed",
          "s3:ObjectRestore:Delete",
          "s3:ReducedRedundancyLostObject",
          "s3:Replication:OperationFailedReplication",
          "s3:Replication:OperationMissedThreshold",
          "s3:Replication:OperationReplicatedAfterThreshold",
          "s3:Replication:OperationNotTracked",
          "s3:LifecycleExpiration:Delete",
          "s3:LifecycleExpiration:DeleteMarkerCreated",
          "s3:LifecycleTransition",
          "s3:IntelligentTiering",
          "s3:ObjectTagging:Put",
          "s3:ObjectTagging:Delete",
          "s3:ObjectAcl:Put"
        ]
        topic_arn = "arn:aws:sns:us-east-1:123456789012:s3-bucket-notification"
      }
    ]
  }
```


## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_bucket_notification"></a> [enable\_bucket\_notification](#input\_enable\_bucket\_notification) | Whether to enable bucket notification | `bool` | `true` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the pipeline s3 bucket. | `string` | `null` | no |

## Outputs

No outputs.
