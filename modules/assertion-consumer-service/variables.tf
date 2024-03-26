variable "enviorment" {
  description = "Enviorment"
  type        = string
  default     = "dev"
}

variable "projectName" {
  description = "The name of the project"
  type        = string
  default     = "assertion-consumer-service"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string

}

variable "public_subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID"
  type        = string

}

variable "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"

}

variable "ecs_tasks_sg_id" {
  description = "The ID of the ECS tasks security group"

}

variable "target_group_arn" {
  description = "The ARN of the target group"
}
