# Define security group for RDS
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Allow PostgreSQL traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to limit access if needed
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_tasks_sg_id]
  }
  tags = {
    Name        = "RDS Security Group"
    Environment = "dev"
  }
}

# Define DB subnet group
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name        = "RDS Subnet Group"
    Environment = "dev"
  }
}

# Create RDS instance
resource "aws_db_instance" "my_rds_instance" {
  identifier             = "my-rds-instance"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name # Using the DB subnet group created earlier
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]  # Assuming you have defined an appropriate security group for the RDS instance
  db_name                = "mydatabase"
  skip_final_snapshot    = true
  username               = "steve"
  password               = "password"
  publicly_accessible    = false

  tags = {
    Name        = "RDS Instance"
    Environment = "dev"
  }
}


