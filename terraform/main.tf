provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
    }]
  })
}

resource "aws_codedeploy_app" "app" {
  name = "devops-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "app_group" {
  app_name = aws_codedeploy_app.app.name
  deployment_group_name = "devops-deployment-group"
  service_role_arn = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_type = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  ec2_tag_set {
    ec2_tag_filter {
      key = "Name"
      type = "KEY_AND_VALUE"
      value = "MyEC2Instance"
    }
  }
}
