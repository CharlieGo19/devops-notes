resource "aws_s3_bucket" "s3_bucket_replication_source" {
  bucket = var.source_bucket_name
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_replication_source" {
  bucket = aws_s3_bucket.s3_bucket_replication_source.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "source_allow_public_access" {
  bucket = aws_s3_bucket.s3_bucket_replication_source.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "source_allow_anonymous_principle_access" {
  bucket = aws_s3_bucket.s3_bucket_replication_source.id
  policy = data.aws_iam_policy_document.source_allow_anonymous_principle_access_document.json
}

resource "aws_s3_bucket_versioning" "source_s3_bucket_versioning_enabled" {
    bucket = aws_s3_bucket.s3_bucket_replication_source.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket" "s3_bucket_replication_destination" {
  bucket = var.destination_bucket_name
}

resource "aws_s3_bucket_website_configuration" "destination_s3_bucket_replication" {
  bucket = aws_s3_bucket.s3_bucket_replication_destination.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_access_destination" {
  bucket = aws_s3_bucket.s3_bucket_replication_destination.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "destination_allow_anonymous_principle_access" {
  bucket = aws_s3_bucket.s3_bucket_replication_destination.id
  policy = data.aws_iam_policy_document.destination_allow_anonymous_principle_access_document.json
}

resource "aws_s3_bucket_versioning" "destination_s3_bucket_versioning_enabled" {
    bucket = aws_s3_bucket.s3_bucket_replication_destination.id
    versioning_configuration {
      status = "Enabled"
    }
}

# https://docs.aws.amazon.com/AmazonS3/latest/userguide/setting-repl-config-perm-overview.html
resource "aws_s3_bucket_replication_configuration" "aws_s3_replication_configuration_source" {
  # Replication has a dependency on versioning being enabled.
  depends_on = [
    aws_s3_bucket_versioning.source_s3_bucket_versioning_enabled,
    aws_s3_bucket_versioning.destination_s3_bucket_versioning_enabled
   ]

   role      = var.aws_iam_role_s3_replication_arn
   bucket    = aws_s3_bucket.s3_bucket_replication_source.id

  rule {
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.s3_bucket_replication_destination.arn
      storage_class = "STANDARD"
    }

    filter {
      # empty filter block is required to use delete_marker_replication and existing_object_replication
    }

    delete_marker_replication {
      status = "Disabled"
    }

    # At time of coding, replication for existing objects requires activation by AWS Support.
    /*existing_object_replication {
      status = "Enabled"
    }*/
  }
}

resource "aws_s3_object" "s3_bucket_replication_source_index_html" {
  # S3 Replication does not apply retroactively, therefore have configuration in place before
  # objects are uploaded.
  depends_on = [ aws_s3_bucket_replication_configuration.aws_s3_replication_configuration_source ]

  bucket       = aws_s3_bucket.s3_bucket_replication_source.id
  key          = "index.html"
  source       = "${path.root}/../website/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "s3_bucket_replication_source_image" {
  depends_on = [ aws_s3_bucket_replication_configuration.aws_s3_replication_configuration_source ]

  bucket       = aws_s3_bucket.s3_bucket_replication_source.id
  key          = "s3-replication-source-stag.png"
  source       = "${path.root}/../objects/s3-replication-source-stag.png"
  content_type = "image/png"
}
