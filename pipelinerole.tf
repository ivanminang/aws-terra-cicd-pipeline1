resource "aws_iam_role" "pipeline" {
  name = "terra_codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "pipeline" {
  statement {
    sid       = ""
    actions   = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    sid       = ""
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "pipeline" {
  name        = "terraform_codepipeline_policy"
  path        = "/"
  description = "CodePipeline policy"
  policy      = data.aws_iam_policy_document.pipeline.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.pipeline.arn
  role       = aws_iam_role.pipeline.id
}