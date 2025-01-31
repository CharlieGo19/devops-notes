variable "AWS_S3_BUCKET_PREFIX" {
    type    = string
    default = "charliego-aws-learning"
}

variable "AWS_S3_BUCKET_REGION" {
    type    = string
    default = "us-east-1"
}

variable "AWS_S3_WEBSITE_CONFIGURATION_INDEX_DOCUMENT" {
    description = "Value to satisfy the index document requirement for S3's static website hosting."
    type        = string
    default     = "index.html"
}

variable "AWS_S3_WEBSITE_CONFIGURATION_ERROR_DOCUMENT" {
    description = "Value to satisfy the error document requirement for S3's static website hosting."
    type        = string
    default     = "error.html"
}