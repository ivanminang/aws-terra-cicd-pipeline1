resource "aws_iam_role" "build" {
  name = "terra_codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "build" {
  statement {
    sid       = ""
    actions   = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*", "iam:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "build" {
  name        = "terra_codebuild_policy"
  path        = "/"
  description = "Codebuild policy"
  policy      = data.aws_iam_policy_document.build.json
}

resource "aws_iam_role_policy_attachment" "attachment1" {
  policy_arn = aws_iam_policy.build.arn
  role       = aws_iam_role.build.id
}

resource "aws_iam_role_policy_attachment" "attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role       = aws_iam_role.build.id
}