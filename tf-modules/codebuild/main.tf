# CodeBuild Projects

# 1. Backend CodeBuild Project
resource "aws_codebuild_project" "backend_build" {
  name          = "${var.project_name}-backend-build"
  description   = "CodeBuild project to build and package Backend Docker container for ${var.project_name}"
  build_timeout = "20"
  service_role  = var.backend_build_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "ECR_REPO_URL"
      value = var.backend_ecr_repo_url
    }

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspecs/backend_buildspec.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}-backend-build"
      status      = "ENABLED"
    }
  }
}

# 2. Frontend CodeBuild Project
resource "aws_codebuild_project" "frontend_build" {
  name          = "${var.project_name}-frontend-build"
  description   = "CodeBuild project to build and deploy Frontend React app for ${var.project_name}"
  build_timeout = "20"
  service_role  = var.frontend_build_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "S3_BUCKET_NAME"
      value = var.frontend_bucket_id
    }

    environment_variable {
      name  = "CLOUDFRONT_DIST_ID"
      value = var.cloudfront_distribution_id
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspecs/frontend_buildspec.yml")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}-frontend-build"
      status      = "ENABLED"
    }
  }
}
