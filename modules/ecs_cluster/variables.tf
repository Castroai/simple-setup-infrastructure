variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "vpc_id" {
  description = "value of the vpc id"
}

variable "load_balancer_security_group_id" {
  description = "The ID of the load balancer security group"

}
