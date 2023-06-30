output "bucket_arn" {
  value       = one(aws_s3_bucket.this[*].arn)
  description = "ARN of the S3 bucket"
}

output "bucket_id" {
  value       = one(aws_s3_bucket.this[*].id)
  description = "ID of the S3 bucket"
}

output "bucket_domain_name" {
  value       = one(aws_s3_bucket.this[*].bucket_domain_name)
  description = "Domain name of this S3 bucket"
}

output "website_domain" {
  value       = one(aws_s3_bucket_website_configuration.this[*].website_domain)
  description = "Domain of the website endpoint. This is used to create Route 53 alias records."
}

output "website_endpoint" {
  value       = one(aws_s3_bucket_website_configuration.this[*].website_endpoint)
  description = "Website endpoint of the S3 bucket"
}