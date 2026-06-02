resource "aws_codecommit_repository" "app_repo" {
  repository_name = "${var.project_name}-repo"
  description     = "AWS CodeCommit repository containing all application codes and infrastructure files for ${var.project_name}."
}
