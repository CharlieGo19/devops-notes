terraform {
   required_providers {
     aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
     }
   }
   required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3_basic_static_website" {
    bucket = "${random_uuid.uuid.result}"
}

resource "aws_s3_bucket_website_configuration" "s3_basic_static_website_conf" {
    bucket = aws_s3_bucket.s3_basic_static_website.id

    index_document {
      suffix = var.AWS_S3_WEBSITE_CONFIGURATION_INDEX_DOCUMENT
    }

    error_document {
      key = var.AWS_S3_WEBSITE_CONFIGURATION_ERROR_DOCUMENT
    }
}

locals {
    raw_files   = fileset("${path.root}/../website_files", "**/*.*")
    fltrd_files = toset([for file in local.raw_files : file if can(regex("^[^.].+", file))])
}

resource "aws_s3_object" "s3_basic_static_website_filefolders" {
    for_each    = local.fltrd_files
    bucket           = aws_s3_bucket.s3_basic_static_website.bucket
    key              = "${each.value}"
    source           = "${path.root}/../website_files/${each.value}"
    content_type     =  strcontains(each.value, "html") ? "text/html" : "image/jpeg"
    etag             = "${path.root}/../website_files/${each.value}"
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
    bucket = aws_s3_bucket.s3_basic_static_website.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_anonymous_principle_access" {
    bucket = aws_s3_bucket.s3_basic_static_website.id
    policy = data.aws_iam_policy_document.allow_anonymous_principle_access_document.json
}

data "aws_iam_policy_document" "allow_anonymous_principle_access_document" {
    version = "2012-10-17"
    statement {
      sid      = "PublicRead"
      effect   = "Allow"
      actions = [ "s3:GetObject" ]
      principals {
        type = "*"
        identifiers = [ "*" ]
      }
      resources = [  
        "${aws_s3_bucket.s3_basic_static_website.arn}/*"
      ]
    }
}

resource "random_uuid" "uuid" {}
