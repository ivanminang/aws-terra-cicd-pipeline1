resource "aws_iam_role" "deploy" {
  name = "terra_deploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deploy.name
}


resource "aws_codedeploy_app" "terra" {
  compute_platform = "Server"  #"Lambda" #"ECS"
  name             = "terra_app"
#   tags = merge(
#     { "ResourceName" = var.cd_app_name }, var.tags
#   )
}

# resource "aws_codedeploy_deployment_config" "this" {
#   deployment_config_name = "${var.cd_app_name}-deployment-config"
#   compute_platform       = "Lambda"
#     traffic_routing_config {
#     type = "TimeBasedLinear"

#     time_based_linear {
#       interval   = 10
#       percentage = 10
#     }
#   }
# }




resource "aws_codedeploy_deployment_group" "terra" {
  app_name               = aws_codedeploy_app.terra.name
  deployment_group_name  = "terra-deploy-grp"
  service_role_arn       = aws_iam_role.deploy.arn
  deployment_config_name =  "CodeDeployDefault.OneAtATime"
  #deployment_config_name = aws_codedeploy_deployment_config.this.id
#   trigger_configuration {
#     trigger_events = ["DeploymentFailure", "DeploymentSuccess", "DeploymentFailure", "DeploymentStop",
#     "InstanceStart", "InstanceSuccess", "InstanceFailure"]
#     trigger_name       = "terra_trigger"
#     trigger_target_arn = aws_sns_topic.this.arn
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }

#   deployment_style {
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#     deployment_type   = "BLUE_GREEN" #"IN_PLACE"
#   }

#   alarm_configuration {
#     alarms  = var.alarms # ["my-alarm-name"]
#     enabled = true
#   }
}

# resource "aws_sns_topic" "this" {
#   name = "${var.cd_app_name}-sns-topic"
# }