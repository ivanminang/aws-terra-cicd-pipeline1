

# #******************iam role and policies for codepipeline***************************
# # policy document for assume codepipeline role
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["codepipeline.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# #  codepipeline role
# resource "aws_iam_role" "codepipeline_role" {
#   name               = "terra-codepipeline-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# # policy document for codepipeline
# data "aws_iam_policy_document" "codepipeline_policy" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:GetObject",
#       "s3:GetObjectVersion",
#       "s3:GetBucketVersioning",
#       "s3:PutObjectAcl",
#       "s3:PutObject",
#     ]

#     resources = [
#       aws_s3_bucket.codepipeline_artifacts_bucket1.arn,   # this is the bucket where codepipeline will store the artifacts
#       "${aws_s3_bucket.codepipeline_artifacts_bucket1.arn}/*",
#     ]
#   }

#   statement {
#     effect    = "Allow"
#     actions   = ["codestar-connections:UseConnection"]
#     resources = [var.codestar_connector_credentials]
#     # resources = [aws_codestarconnections_connection.example.arn]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "codebuild:BatchGetBuilds",
#       "codebuild:StartBuild",
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "codepipeline_policy" {
#   name   = "codepipeline_policy"
#   role   = aws_iam_role.codepipeline_role.id
#   policy = data.aws_iam_policy_document.codepipeline_policy.json
# }


# #******************iam role and policies for codebuild***************************

# data "aws_iam_policy_document" "assume_roleb" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["codebuild.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "codebuild_role" {
#   name               = "terra_codebuild_role"
#   assume_role_policy = data.aws_iam_policy_document.assume_roleb.json
# }

# data "aws_iam_policy_document" "codebuild" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "ec2:CreateNetworkInterface",
#       "ec2:DescribeDhcpOptions",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DeleteNetworkInterface",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeVpcs",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     effect    = "Allow"
#     actions   = ["ec2:CreateNetworkInterfacePermission"]
#     resources = ["arn:aws:ec2:us-east-1:123456789012:network-interface/*"]

#   }
#   statement {
#     effect    = "Allow"
#     actions   = ["secretsmanager:GetSecretValue"]
#     resources = [var.dockerhub_credentials]
#   }

#   statement {
#     effect  = "Allow"
#     actions = ["s3:*"]
#     resources = [
#       aws_s3_bucket.codepipeline_artifacts_bucket1.arn,   # this is the bucket where codepipeline will store the artifacts
#       "${aws_s3_bucket.codepipeline_artifacts_bucket1.arn}/*",
#     ]
#   }
#   statement {
#     effect  = "Allow"
#     actions = ["s3:*"]
#     resources = ["arn:aws:s3:::aws-terra-cicd-pipeline1/dev/terraform.tfstate"]
#   }

#   statement {
#     sid = "decodepolicy"
#     effect  = "Allow"
#     actions = ["sts:DecodeAuthorizationMessage"]
#     resources = ["*"]
#   }

#   statement {
#     effect  = "Allow"
#     actions = ["iam:PassRole"]
#     resources = ["arn:aws:iam::462792239034:role/*"]
#   }
# }

# resource "aws_iam_role_policy" "codebuild" {
#   role   = aws_iam_role.codebuild_role.name
#   policy = data.aws_iam_policy_document.codebuild.json
# }