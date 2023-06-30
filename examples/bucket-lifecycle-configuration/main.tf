module "s3" {
  source = "../../"

  s3_bucket_name                 = var.s3_bucket_name
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
          days          = 30
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
    }
  ]
}