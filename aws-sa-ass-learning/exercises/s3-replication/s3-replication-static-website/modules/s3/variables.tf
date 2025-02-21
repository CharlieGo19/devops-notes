variable "source_bucket_name" {
  description = "Name of the primary S3 Bucket to be replicated. Must be unique"
  type        = string
}

variable "destination_bucket_name" {
  description = "Name of the backup S3 Bucket. Must be unique"
  type        = string
}

variable "aws_iam_role_s3_replication_arn" {
  description = "ARN of the IAM Role AWS S3 assumes in order to do S3 Replication."
  type        = string
}