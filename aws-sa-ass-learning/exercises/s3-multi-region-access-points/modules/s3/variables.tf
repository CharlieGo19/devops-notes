variable "uk_bucket_name" {
  description = "Name of distinct region S3 Bucket for Multi-Region Access Points demo."
  type        = string
}

variable "can_bucket_name" {
  description = "Name of distinct region S3 Bucket for Multi-Region Access Points demo."
  type        = string
}

variable "canuk_access_point_name" {
  description = "Name of the Multi-Region Access Point linking The UK and Canada."
  type        = string
}

variable "canuk_iam_role" {
  description = "ARN of the role responsible for S3 Object Replication."
  type        = string
}