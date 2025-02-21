data "aws_iam_policy_document" "source_allow_anonymous_principle_access_document" {
  version     = "2012-10-17"
  statement {
    sid       = "PublicRead"
    effect    = "Allow"
    actions   = [ "s3:GetObject" ]
    principals {
      type = "*"
      identifiers = [ "*" ]
    }
    resources = [ 
      "${aws_s3_bucket.s3_bucket_replication_source.arn}/*" 
    ]
  }
}

data "aws_iam_policy_document" "destination_allow_anonymous_principle_access_document" {
  version     = "2012-10-17"
  statement {
    sid       = "PublicRead"
    effect    = "Allow"
    actions   = [ "s3:GetObject" ]
    principals {
      type = "*"
      identifiers = [ "*" ]
    }
    resources = [ "${aws_s3_bucket.s3_bucket_replication_destination.arn}/*" ]
  }
  statement {
    sid = "AllowGetVersioning"
    effect = "Allow"
    actions = [ "s3:GetBucketVersioning" ]
    principals {
      type = "AWS"
      identifiers = [ 
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" 
      ]
    }
    resources = [ aws_s3_bucket.s3_bucket_replication_destination.arn ]
  }
}

data "aws_caller_identity" "current" {}