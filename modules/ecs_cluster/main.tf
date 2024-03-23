# Create ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = {
    name        = "Elastic Container Service Cluster"
    environment = "dev"
  }
}

