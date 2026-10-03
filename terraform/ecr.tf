data "aws_ecr_repository" "backend" {
  name = "clouddeploy-backend"
}

data "aws_ecr_repository" "frontend" {
  name = "clouddeploy-frontend"
}