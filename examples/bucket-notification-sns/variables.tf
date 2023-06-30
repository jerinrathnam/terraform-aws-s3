
variable "s3_bucket_name" {
  type        = string
  description = "Name of the pipeline s3 bucket."
  default     = null
}

variable "enable_bucket_notification" {
  type        = bool
  description = "Whether to enable bucket notification"
  default     = true
}