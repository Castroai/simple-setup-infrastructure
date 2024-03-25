
# Purpose: Create an ECR repository
resource "aws_ecr_repository" "ecr_repo" {
  name = "web-app-dev-ecr"
  tags = {
    Name        = "Elastic Continer Repository"
    Environment = "dev"
  }
}
