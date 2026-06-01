# Create ECS Task Execution Role
resource "aws_iam_role" "task_execution_role" {
  name = var.task_execution_role_name  
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