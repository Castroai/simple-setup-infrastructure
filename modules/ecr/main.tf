# Purpose: Create an ECR repository
resource "aws_ecr_repository" "ecr_repo" {
  name = var.repository_name
  tags = {
    name        = "Elastic Continer Repository"
    environment = "dev"
  }
}
