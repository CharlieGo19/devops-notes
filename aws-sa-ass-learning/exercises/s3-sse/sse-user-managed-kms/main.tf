terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.82"
    }
  }
  required_version = ">= 1.2.0"
}

/*********************************************************************************
* Before running this exercise, please read: https://aws.amazon.com/kms/pricing/ *
*********************************************************************************/

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3_user_managed_kms_encryption_demo" {
  bucket = "sse-test-user-kms-${random_string.s3_bucket_suffix.result}"
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_user_managed_kms_encryption_demo" {
  bucket = aws_s3_bucket.s3_user_managed_kms_encryption_demo.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_alias.test_key_i.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_kms_key" "test_key_i" {
  description         = "Test Key for AWS Demonstration."
  enable_key_rotation = false
  policy              = data.aws_iam_policy_document.kms.json
}

# Use the alias instead of actual key, this allows for easier maintenance with key rotation.

resource "aws_kms_alias" "test_key_i" {
  name          = "alias/test-key-1"
  target_key_id = aws_kms_key.test_key_i.id
}

# This can also be achieved via:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy

data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
}

resource "aws_s3_object" "object_one_default_encryption" {
  bucket         = aws_s3_bucket.s3_user_managed_kms_encryption_demo.id
  key            = "object_one_kms_customer_managed_key_encryption"
  source         = "${path.root}/../objects/sse-s3-god-deer.png"
  content_type   = "image/png"

  depends_on = [ aws_kms_alias.test_key_i ]
}

resource "random_string" "s3_bucket_suffix" {
  length  = 6
  special = false  
  upper   = false
}

data "aws_caller_identity" "current" {}
