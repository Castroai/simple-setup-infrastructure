variable "enviorment" {
  description = "Enviorment"
  type        = string
  default     = "dev"
}



variable "projectName" {
  description = "The name of the project"
  type        = string
  default     = "simple-setup-web-app"
}

variable "ecs_execution_role_arn" {
  description = "value of the ECS execution role ARN"
}

variable "ecs_cluster_id" {
  description = "value of the ECS cluster ID"
}

variable "target_group_arn" {
  description = "value of the target group ARN"
}
variable "private_subnet_ids" {
  description = "value of the private subnet IDs"
  type        = list(string)
}

variable "ecs_tasks_sg_id" {
  description = "value of the ECS tasks security group ID"
}
