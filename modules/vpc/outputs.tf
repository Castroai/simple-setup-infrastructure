
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}


output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] # Include both subnets
}
