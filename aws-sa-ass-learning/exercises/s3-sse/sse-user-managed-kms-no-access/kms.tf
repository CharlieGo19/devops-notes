resource "aws_kms_key" "test_key_i" {
  description         = "Test Key for AWS Demonstration."
  enable_key_rotation = false
  policy              = data.aws_iam_policy_document.kms.json
}

resource "aws_kms_alias" "test_key_i" {
  name          = "alias/test-key-1"
  target_key_id = aws_kms_key.test_key_i.id
}

/***********************************************
* Here we demonstrate how we can achieve role  *
* separation, in reality you'd have separate   *
* accounts, however we're doing this with our  *
* root account. If you check object_two in the *
* created S3 bucket, you should see an access  *
* denied page, this is because we're using a   *
* customer managed key, and on that key, you   *
* don't have the decrypt permissions.          *
***********************************************/

data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"
  
  # Minimum administrative requirements.
  statement {
    sid = "AllowKeyManagement"
    effect = "Allow"
    actions = [
      "kms:PutKeyPolicy",
      "kms:GetKeyPolicy",
      "kms:ListKeyPolicies",
      "kms:DescribeKey",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags"
    ]
    principals {
      type = "AWS"
      identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" ]
    }
    resources = [ "*" ]
  }

  statement {
    sid = "AllowEncryption"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    principals {
      type        = "AWS"
      identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" ]
    }
    resources = [ "*" ]
  }

  statement {
    sid       = "DenyDecryption"
    effect    = "Deny"
    actions   = [
      "kms:Decrypt",
    ]
    principals {
      type        = "AWS"
      identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" ]
    }
    resources = [ "*" ]
  }
}

# Note: Remember to restore your privileges for the KMS Key using the following documentation: 
# https://docs.aws.amazon.com/cli/latest/reference/kms/put-key-policy.html
# If you check object_two once privileges have been restored, you should be able to view the file.