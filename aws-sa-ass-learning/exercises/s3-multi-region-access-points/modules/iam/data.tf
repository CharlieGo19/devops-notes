data "aws_iam_policy_document" "aws_s3_role_mrap_crr_canuk" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

// Here I'm creating a single IAM Policy Document for the Multi-Region Access Point, with the single purpose of
// Cross Region Replication within the same account & organisation, so there's no need for any other separation
// of concerns.
data "aws_iam_policy_document" "aws_s3_iam_mrap_crr_canuk" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObject",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    resources = [
      var.s3_bucket_can_arn,
      var.s3_bucket_uk_arn,
      "${var.s3_bucket_can_arn}/*",
      "${var.s3_bucket_uk_arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    condition {
      test     = "StringLikeIfExists"
      variable = "s3:x-amz-server-side-encryption"
      values = [
        "aws:kms",
        "aws:kms:dsse",
        "AES256"
      ]
    }
    resources = [
      "${var.s3_bucket_can_arn}/*",
      "${var.s3_bucket_uk_arn}/*"
    ]
  }
  // We have multiple Encrypt/Decrypt statements due to the locale of the S3 buckets and where the service is used.
  statement {
    // Canada Decrypt
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.ca-central-1.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["${var.s3_bucket_can_arn}/*"]
    }
    resources = ["arn:aws:kms:ca-central-1:${data.aws_caller_identity.current.account_id}:alias/aws/s3"]
  }
  statement {
    // The United Kingdom Decrypt
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.eu-west-2.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["${var.s3_bucket_uk_arn}/*"]
    }
    resources = ["arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/aws/s3"]
  }
  statement {
    // Canada Encrypt
    effect  = "Allow"
    actions = ["kms:Encrypt"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.ca-central-1.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["${var.s3_bucket_can_arn}/*"]
    }
    resources = ["arn:aws:kms:ca-central-1:${data.aws_caller_identity.current.account_id}:alias/aws/s3"]
  }
  statement {
    // The United Kingdom Encrypt
    effect  = "Allow"
    actions = ["kms:Encrypt"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.eu-west-2.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["${var.s3_bucket_uk_arn}/*"]
    }
    resources = ["arn:aws:kms:eu-west-2:${data.aws_caller_identity.current.account_id}:alias/aws/s3"]
  }
}

data "aws_caller_identity" "current" {}