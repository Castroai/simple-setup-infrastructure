
variable "db_name" {
  description = "The name of the database to create on the RDS instance"
}

# variable "db_password" {
#   description = "The password for the database user"
# }


# variable "db_username" {
#   description = "The username for the database user"
# }



variable "vpc_id" {
  description = "The VPC ID to place the RDS instance"

}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets to place the RDS instance"

}


variable "ecs_tasks_sg_id" {
  description = "The ID of the security group for the ECS tasks"

}
