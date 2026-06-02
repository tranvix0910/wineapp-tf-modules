# IAM Roles for CodeBuild

# 1. Backend Build Role
resource "aws_iam_role" "backend_build_role" {
  name = "${var.project_name}-backend-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "backend_build_policy" {
  name = "${var.project_name}-backend-codebuild-policy"
  role = aws_iam_role.backend_build_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.artifacts_bucket_arn,
          "${var.artifacts_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# 2. Frontend Build Role
resource "aws_iam_role" "frontend_build_role" {
  name = "${var.project_name}-frontend-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "frontend_build_policy" {
  name = "${var.project_name}-frontend-codebuild-policy"
  role = aws_iam_role.frontend_build_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.artifacts_bucket_arn,
          "${var.artifacts_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.frontend_bucket_arn,
          "${var.frontend_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# CodeBuild Projects

# 1. Backend CodeBuild Project
resource "aws_codebuild_project" "backend_build" {
  name          = "${var.project_name}-backend-build"
  description   = "CodeBuild project to build and package Backend Docker container for ${var.project_name}"
  build_timeout = "20"
  service_role  = aws_iam_role.backend_build_role.arn

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
    buildspec = <<EOF
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=$${COMMIT_HASH:-latest}
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - cd wineapp-backend
      - docker build --platform linux/amd64 -t $ECR_REPO_URL:$IMAGE_TAG .
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push $ECR_REPO_URL:$IMAGE_TAG
      - echo Generating taskdef.json and appspec.json dynamically...
      - aws ecs describe-task-definition --task-definition $PROJECT_NAME-backend-task-definition --query taskDefinition > taskdef_raw.json
      - python3 -c "import json; d=json.load(open('taskdef_raw.json')); [d.pop(k, None) for k in ['taskDefinitionArn', 'revision', 'status', 'requiresAttributes', 'compatibilities', 'registeredAt', 'registeredBy']]; json.dump(d, open('../taskdef.json', 'w'))"
      - printf '{"version":0.0,"Resources":[{"TargetService":{"Type":"AWS::ECS::Service","Properties":{"TaskDefinition":"<TASK_DEFINITION>","LoadBalancerInfo":{"ContainerName":"%s","ContainerPort":4000}}}}]}' "$PROJECT_NAME-backend" > ../appspec.json
      - printf '[{"name":"%s","imageUri":"%s"}]' "$PROJECT_NAME-backend" "$ECR_REPO_URL:$IMAGE_TAG" > ../imageDetail.json
      - cd ..
      - echo Files prepared:
      - ls -la taskdef.json appspec.json imageDetail.json

artifacts:
  files:
    - taskdef.json
    - appspec.json
    - imageDetail.json
EOF
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
  service_role  = aws_iam_role.frontend_build_role.arn

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
    buildspec = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 18
  build:
    commands:
      - echo Build started on `date`
      - cd wineapp-frontend
      - npm install
      - npm run build
  post_build:
    commands:
      - echo Deploying to S3 bucket $S3_BUCKET_NAME...
      - aws s3 sync build/ s3://$S3_BUCKET_NAME --delete
      - echo Invalidating CloudFront cache for distribution $CLOUDFRONT_DIST_ID...
      - aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DIST_ID --paths "/*"
      - echo Frontend deployment completed on `date`
EOF
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}-frontend-build"
      status      = "ENABLED"
    }
  }
}
