

variable "s3_bucket_name" {
  type        = string
  description = "Name of the pipeline s3 bucket."
  default     = null
}

variable "create_bucket_policy" {
  type        = bool
  description = "Wheter to create bucket policy"
  default     = true
}