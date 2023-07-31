

resource "aws_codebuild_project" "terra" {
  name          = "terra-project"
  description   = "terra_codebuild_project"
#   build_timeout = "5"
  service_role  = aws_iam_role.build.arn

  artifacts {
    type =   "S3"  #"NO_ARTIFACTS"    #"CODEPIPELINE"
    location = aws_s3_bucket.codepipeline_artifacts_bucket1.bucket
  }
  # cache {
  #   type     = "S3"
  #   location = aws_s3_bucket.example.bucket
  # }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    # image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    image                       = "hashicorp/terraform:1.4.5" # (Docker image from my Docker Hub) # "aws/codebuild/amazonlinux2-x86_64-standard:4.0" (this is Docker Image provided by codebuild)
    type                        = "LINUX_CONTAINER"
    # image_pull_credentials_type = "CODEBUILD" (codebuild is when you use am aws Codebuild curated image)
    image_pull_credentials_type = "SERVICE_ROLE" #(service role is when you use private registery image) 
    registry_credential {
      credential = var.dockerhub_credentials
      credential_provider = "SECRETS_MANAGER"
    }
    # environment_variable {
    #   name = "AWS_ACCESS_KEY_ID"
    #   value = "${var.access_key}"
    # }
    # environment_variable {
    #   name = "AWS_SECRET_ACCESS_KEY"
    #   value = "${var.secret_key}"
    # }
    
  }

  source {
    type            = "GITHUB"  #"CODEPIPELINE"
    location        = "https://github.com/ivanminang/terra_codepipeline_proj15.git"  #(This is the location of our application code)
    # git_clone_depth = 1
    buildspec = file("buildspec/plan_buildspec.yaml")
  }
  source_version = "main" # (this is the branch of our application code)
}



    # environment_variable {
    #   name  = "SOME_KEY1"
    #   value = "SOME_VALUE1"
    # }

    # environment_variable {
    #   name  = "SOME_KEY2"
    #   value = "SOME_VALUE2"
    #   type  = "PARAMETER_STORE"
    # }
# }

#   logs_config {
#     cloudwatch_logs {
#       group_name  = "log-group"
#       stream_name = "log-stream"
#     }

#     s3_logs {
#       status   = "ENABLED"
#       location = "${aws_s3_bucket.example.id}/build-log"
#     }
#   }

#     git_submodules_config {
#       fetch_submodules = true
#     }
#   }

#   source_version = "master"

#   vpc_config {
#     vpc_id = aws_vpc.example.id

#     subnets = [
#       aws_subnet.example1.id,
#       aws_subnet.example2.id,
#     ]

#     security_group_ids = [
#       aws_security_group.example1.id,
#       aws_security_group.example2.id,
#     ]
#   }

#   tags = {
#     Environment = "Test"
#   }
# }

# resource "aws_codebuild_project" "project-with-cache" {
#   name           = "test-project-cache"
#   description    = "test_codebuild_project_cache"
#   build_timeout  = "5"
#   queued_timeout = "5"

#   service_role = aws_iam_role.example.arn

#   artifacts {
#     type = "NO_ARTIFACTS"
#   }

#   cache {
#     type  = "LOCAL"
#     modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
#   }

#   environment {
#     compute_type                = "BUILD_GENERAL1_SMALL"
#     image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
#     type                        = "LINUX_CONTAINER"
#     image_pull_credentials_type = "CODEBUILD"

#     environment_variable {
#       name  = "SOME_KEY1"
#       value = "SOME_VALUE1"
#     }
#   }

#   source {
#     type            = "GITHUB"
#     location        = "https://github.com/mitchellh/packer.git"
#     git_clone_depth = 1
#   }

#   tags = {
#     Environment = "Test"
#   }
# }