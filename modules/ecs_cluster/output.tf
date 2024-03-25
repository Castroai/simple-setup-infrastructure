output "cluster_id" {
  description = "The ID of the created ECS cluster."
  value       = aws_ecs_cluster.cluster.id
}

output "ecs_tasks_sg_id" {
  value = aws_security_group.my_securitygroup.id
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}
