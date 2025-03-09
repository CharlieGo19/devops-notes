resource "aws_iam_role" "aws_s3_role_mrap_crr_canuk" {
  name               = "aws_s3_role_mrap_crr_canuk"
  assume_role_policy = data.aws_iam_policy_document.aws_s3_role_mrap_crr_canuk.json
}

resource "aws_iam_policy" "aws_s3_iam_mrap_crr_canuk" {
  name   = "aws_s3_iam_mrap_crr_canuk"
  policy = data.aws_iam_policy_document.aws_s3_iam_mrap_crr_canuk.json
}

resource "aws_iam_role_policy_attachment" "aws_s3_ratt_mrap_crr_canuk" {
  role       = aws_iam_role.aws_s3_role_mrap_crr_canuk.name
  policy_arn = aws_iam_policy.aws_s3_iam_mrap_crr_canuk.arn
}