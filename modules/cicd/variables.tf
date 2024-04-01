variable "aws_ecs_cluster" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service"
}

variable "aws_lb_listener_arn" {
  description = "The ARN of the ALB listener"

}

variable "aws_lb_target_group" {
  description = "value of the target group ARN"
}
