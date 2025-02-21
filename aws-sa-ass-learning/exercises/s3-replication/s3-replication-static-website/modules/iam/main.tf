resource "aws_iam_role" "aws_s3_replication_role" {
  name               = "aws_s3_replication_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_replication.json
}

resource "aws_iam_policy" "aws_s3_replication_iam_policy" {
  name   = "aws_s3_replication_iam_role_policy"
  policy = data.aws_iam_policy_document.source_aws_s3_replication_iam_role.json
}

resource "aws_iam_role_policy_attachment" "aws_s3_replication_iam_policy" {
  role       = aws_iam_role.aws_s3_replication_role.name
  policy_arn = aws_iam_policy.aws_s3_replication_iam_policy.arn
}