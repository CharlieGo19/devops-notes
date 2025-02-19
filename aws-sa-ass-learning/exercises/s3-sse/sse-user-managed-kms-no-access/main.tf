terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.82"
    }
  }
  required_version = ">= 1.2.0"
}

/*************************************************************
* This demo will use AWS managed keys by default, therefore  *
* you should be able to see the plaintext/image of any objs  *
* that do not have an SSE override. The overridden obj will  *
* not be viewable by yourself, as you will not have the      *
* sufficient KMS permissions to decrypt the obj. This shows  *
* how you might have role separation for regulated           *
* environments.                                              *
*************************************************************/

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3_user_managed_kms_no_permissions_demo" {
  bucket = "sse-test-user-kms-noperm-${random_string.s3_bucket_suffix.result}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_user_managed_kms_no_permissions_demo" {
  bucket = aws_s3_bucket.s3_user_managed_kms_no_permissions_demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "object_one_s3_user_managed_kms_no_permissions_demo" {
  bucket         = aws_s3_bucket.s3_user_managed_kms_no_permissions_demo.id
  key            = "object_one_s3_user_managed_kms_no_permissions_demo"
  source         = "${path.root}/../objects/sse-s3-celestial-deer.png"
  content_type   = "image/png"
}

resource "aws_s3_object" "object_two_s3_user_managed_kms_no_permissions_demo" {
  bucket       = aws_s3_bucket.s3_user_managed_kms_no_permissions_demo.id
  key          = "object_two_s3_user_managed_kms_no_permissions_demo"
  source       = "${path.root}/../objects/sse-s3-god-deer.png"
  content_type = "image/png"
  kms_key_id   = aws_kms_alias.test_key_i.target_key_arn # target_key_arn is required for this obj.

  depends_on = [ aws_kms_alias.test_key_i ]
}

resource "random_string" "s3_bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

data "aws_caller_identity" "current" {}