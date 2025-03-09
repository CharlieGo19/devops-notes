terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws",
      configuration_aliases = [aws.s3_london, aws.s3_toronto]
    }
  }
}

resource "aws_s3_bucket" "s3_bucket_uk_mrap_crr_demo" {
  bucket   = var.uk_bucket_name
  provider = aws.s3_london
}

resource "aws_s3_bucket_versioning" "s3_versioning_uk_mrap_crr_demo" {
  bucket   = aws_s3_bucket.s3_bucket_uk_mrap_crr_demo.id
  provider = aws.s3_london

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "s3_replication_uk_mrap_crr_demo" {
  depends_on = [
    aws_s3_bucket_versioning.s3_versioning_uk_mrap_crr_demo,
    aws_s3_bucket_versioning.s3_versioning_can_mrap_crr_demo
  ]

  bucket   = aws_s3_bucket.s3_bucket_uk_mrap_crr_demo.id
  role     = var.canuk_iam_role
  provider = aws.s3_london

  rule {
    id     = "uk_to_canada"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.s3_bucket_can_mrap_crr_demo.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket" "s3_bucket_can_mrap_crr_demo" {
  bucket   = var.can_bucket_name
  provider = aws.s3_toronto
}

resource "aws_s3_bucket_versioning" "s3_versioning_can_mrap_crr_demo" {
  bucket   = aws_s3_bucket.s3_bucket_can_mrap_crr_demo.id
  provider = aws.s3_toronto

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "s3_replication_can_mrap_crr_demo" {
  depends_on = [
    aws_s3_bucket_versioning.s3_versioning_can_mrap_crr_demo,
    aws_s3_bucket_versioning.s3_versioning_uk_mrap_crr_demo
  ]

  bucket   = aws_s3_bucket.s3_bucket_can_mrap_crr_demo.id
  role     = var.canuk_iam_role
  provider = aws.s3_toronto

  rule {
    id     = "canada_to_uk"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.s3_bucket_uk_mrap_crr_demo.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3control_multi_region_access_point" "s3_access_point_canuk_mrap_crr_demo" {
  details {
    name = var.canuk_access_point_name

    region {
      bucket = aws_s3_bucket.s3_bucket_uk_mrap_crr_demo.id
    }

    region {
      bucket = aws_s3_bucket.s3_bucket_can_mrap_crr_demo.id
    }
  }
}