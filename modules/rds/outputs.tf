output "rds_host_url" {
  value = aws_db_instance.my_rds_instance.endpoint
}
# output "db_subnet_group_name" {
#   value = aws_db_subnet_group.my_db_subnet_group.name
# }
