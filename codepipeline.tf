resource "aws_codepipeline" "codepipeline" {
  name     = "terra-test-pipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifacts_bucket1.bucket
    type     = "S3"

    # encryption_key {
    #   id   = data.aws_kms_alias.s3kmskey.arn
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connector_credentials
        FullRepositoryId = "ivanminang/terra_codepipeline_proj15"
        BranchName       = "main"
      }
    }
  }


  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terra.name
      }
    }
  }


  # stage {
  #   name = "Deploy"

  #   action {
  #     name            = "Deploy"
  #     category        = "Build"
  #     owner           = "AWS"
  #     provider        = "CloudFormation"
  #     input_artifacts = ["build_output"]
  #     version         = "1"
  #   #   region          = "us-east-1"

  #     configuration = {
  #       ActionMode     = "REPLACE_ON_FAILURE"
  #       Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
  #       OutputFileName = "CreateStackOutput.json"
  #       StackName      = "terraStack"
  #       TemplatePath   = "build_output::sam-templated.yaml"
  #     }
  #   }
  # }
}