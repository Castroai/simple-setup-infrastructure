
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

variable "public_subnet_ids" {
  description = "The IDs of the public subnets to place the RDS instance"

}

