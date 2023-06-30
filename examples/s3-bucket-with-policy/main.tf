module "s3" {
  source = "../../"

  s3_bucket_name       = var.s3_bucket_name
  create_bucket_policy = var.create_bucket_policy

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