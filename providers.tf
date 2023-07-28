terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # Configure remote state management
  backend "s3" {
    bucket = "aws-terra-cicd-pipeline1"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"

    # # Configure state file locking
    # dynamodb_table = "terraform-state-locking-table"
  }
}
# Provider Block (Define the aws Provider and the region)
provider "aws" {
  region = "us-east-1"
}