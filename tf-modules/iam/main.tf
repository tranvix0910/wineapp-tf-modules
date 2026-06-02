# Create ECS Task Execution Role
resource "aws_iam_role" "task_execution_role" {
  name               = var.task_execution_role_name
  assume_role_policy = file("${path.module}/policies/ecs_assume_role_policy.json")
}

resource "aws_iam_policy" "task_execution_policy" {
  name        = var.task_execution_policy_name
  description = "Policy for ECS task execution role"

  policy = file("${path.module}/policies/task_execution_policy.json")
}

resource "aws_iam_role_policy_attachment" "task_execution_policy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_policy.arn
}

# Create ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = var.task_role_name

  assume_role_policy = file("${path.module}/policies/ecs_assume_role_policy.json")
}

resource "aws_iam_policy" "ecs_task_role_policy" {
  name        = var.task_role_policy_name
  description = "Policy for ECS task role"

  policy = file("${path.module}/policies/ecs_task_policy.json")
}

resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}

# Create CodeDeploy Service Role
resource "aws_iam_role" "codedeploy_service_role" {
  name = var.codedeploy_service_role_name

  assume_role_policy = file("${path.module}/policies/codedeploy_assume_role_policy.json")
}

resource "aws_iam_policy" "codedeploy_service_policy" {
  name        = var.codedeploy_service_policy_name
  description = "Policy for CodeDeploy service role"

  policy = file("${path.module}/policies/codedeploy_service_policy.json")
}

resource "aws_iam_role_policy_attachment" "codedeploy_service_policy_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.codedeploy_service_policy.arn
}

# 1. Backend CodeBuild Role
resource "aws_iam_role" "backend_build_role" {
  name               = var.backend_build_role_name
  assume_role_policy = file("${path.module}/policies/codebuild_assume_role_policy.json")
}

resource "aws_iam_policy" "backend_build_policy" {
  name        = var.backend_build_policy_name
  description = "Policy for CodeBuild backend role"

  policy = templatefile("${path.module}/policies/backend_build_policy.json", {
    artifacts_bucket_arn = "arn:aws:s3:::${var.project_name}-pipeline-artifacts-${var.environment}"
  })
}

resource "aws_iam_role_policy_attachment" "backend_build_policy_attachment" {
  role       = aws_iam_role.backend_build_role.name
  policy_arn = aws_iam_policy.backend_build_policy.arn
}

# 2. Frontend CodeBuild Role
resource "aws_iam_role" "frontend_build_role" {
  name               = var.frontend_build_role_name
  assume_role_policy = file("${path.module}/policies/codebuild_assume_role_policy.json")
}

resource "aws_iam_policy" "frontend_build_policy" {
  name        = var.frontend_build_policy_name
  description = "Policy for CodeBuild frontend role"

  policy = templatefile("${path.module}/policies/frontend_build_policy.json", {
    artifacts_bucket_arn = "arn:aws:s3:::${var.project_name}-pipeline-artifacts-${var.environment}"
    frontend_bucket_arn  = "arn:aws:s3:::${var.project_name}-frontend-${var.environment}"
  })
}


resource "aws_iam_role_policy_attachment" "frontend_build_policy_attachment" {
  role       = aws_iam_role.frontend_build_role.name
  policy_arn = aws_iam_policy.frontend_build_policy.arn
}