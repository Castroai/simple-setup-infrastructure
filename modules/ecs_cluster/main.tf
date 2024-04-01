# Create ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = {
    Name        = "Elastic Container Service Cluster"
    Environment = "dev"
  }
}


# ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
  description = "ECS Execution Role"
  tags = {
    Name        = "Elastic Container Service Execution Role"
    Environment = "dev"
  }
}

# ECS Execution Role Policy
resource "aws_iam_role_policy" "ecs_execution_inline_policy" {
  name = "ecs_execution_inline_policy"
  role = aws_iam_role.ecs_execution_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# ECS Execution Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution_role.name
}

# ECS Service Security Group
resource "aws_security_group" "my_securitygroup" {
  vpc_id      = var.vpc_id
  name        = "ecs-sg"
  description = "Allow traffic to ECS containers"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "Elastic Container Service Security Group"
    Environment = "dev"
  }
}
