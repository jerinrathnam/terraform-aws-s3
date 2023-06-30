
module "s3-notification" {
  source = "../../"

  s3_bucket_name             = var.s3_bucket_name
  enable_bucket_notification = var.enable_bucket_notification
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