resource "aws_codecommit_repository" "backend_repo" {
  repository_name = "${var.project_name}-backend-repo"
  description     = "AWS CodeCommit repository containing Backend code for ${var.project_name}."
}

resource "aws_codecommit_repository" "frontend_repo" {
  repository_name = "${var.project_name}-frontend-repo"
  description     = "AWS CodeCommit repository containing Frontend code for ${var.project_name}."
}
