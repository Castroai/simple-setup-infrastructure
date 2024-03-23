
variable "cluster_id" {
  description = "The ID of the ECS cluster"

}

variable "ecr_image" {
  description = "The URL of the ECR image"

}
variable "public_subnet_ids" {
  description = "The IDs of the subnets"
}
# variable "security_group_id" {
#   description = "The ID of the security group"
# }

variable "vpc_id" {
  description = "The ID of the VPC"

}

variable "rds_host_url" {
  description = "rds_host_url"
}

variable "target_group_arn" {
  description = "value of the target group arn"
}
