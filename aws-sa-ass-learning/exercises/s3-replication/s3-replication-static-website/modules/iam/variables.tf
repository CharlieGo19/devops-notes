variable "s3_bucket_replication_source_arn" {
  description = "ARN of the source S3 Bucket."
  type        = string
}

variable "s3_bucket_replication_destination_arn" {
  description = "ARN of the destination S3 Bucket."
  type        = string
}
