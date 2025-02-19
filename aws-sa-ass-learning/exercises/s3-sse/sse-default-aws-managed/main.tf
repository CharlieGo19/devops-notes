terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.82"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3_default_encryption_demo" {
  bucket = "${random_uuid.uuid.result}"
}

/***********************************************
*  Set default encryption policy to AES-256    *
*  Note: This is a redundant step, AES256 is   *
*  enabled by default now - it is just to      *
*  demonstrate default SSE encryption.         *
***********************************************/


resource "aws_s3_bucket_server_side_encryption_configuration" "s3_default_encryption_demo_ss3_policy" {
  bucket = aws_s3_bucket.s3_default_encryption_demo.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "object_one_default_encryption" {
  bucket         = aws_s3_bucket.s3_default_encryption_demo.id
  key            = "object_one_default_encryption"
  source         = "${path.root}/../objects/sse-s3-god-deer.png"
  content_type   = "image/png"
}

resource "random_uuid" "uuid" {}
