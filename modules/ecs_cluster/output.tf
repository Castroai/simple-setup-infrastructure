output "cluster_id" {
  description = "The ID of the created ECS cluster."
  value       = aws_ecs_cluster.cluster.id
}
