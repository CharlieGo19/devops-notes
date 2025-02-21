data "aws_iam_policy_document" "assume_role_for_replication" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [ "s3.amazonaws.com" ]
    }

    actions = [ "sts:AssumeRole" ]
  }
}

data "aws_iam_policy_document" "source_aws_s3_replication_iam_role" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = [ 
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    resources = [ 
      var.s3_bucket_replication_source_arn, 
      "${var.s3_bucket_replication_source_arn}/*", 
      var.s3_bucket_replication_destination_arn, 
      "${var.s3_bucket_replication_destination_arn}/*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [ 
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    resources = [
      "${var.s3_bucket_replication_source_arn}/*",
      "${var.s3_bucket_replication_destination_arn}/*"
    ]
  }
}