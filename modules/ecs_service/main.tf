# ECS Service with load balancer and security group
resource "aws_ecs_service" "my_service" {
  name                = "my-service"
  cluster             = var.cluster_id
  task_definition     = aws_ecs_task_definition.my_task.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "asc-api-service"
    container_port   = 80
  }
  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.my_securitygroup.id]
    assign_public_ip = true
  }

  desired_count        = 1
  force_new_deployment = true
  tags = {
    Name        = "ECS Service"
    Environment = "dev"

  }
}

# CloudWatch log group
resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/ecs/asc-api-service"
  tags = {
    Name        = "CloudWatch Log Group"
    Environment = "dev"

  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  depends_on = [aws_cloudwatch_log_group.my_log_group]
  family     = "asc-api-service"
  container_definitions = jsonencode([
    {
      environment = [
        {
          name  = "DATABASE_URL"
          value = "postgresql://steve:password@${var.rds_host_url}/mydatabase?schema=public"
        },
        {
          name  = "ALLOWED_ORIGIN",
          value = "http://localhost:3000"
        },
        {
          name  = "CALLBACK_URL_EXTERNAL",
          value = "http://localhost:8080/openid/callback/"
        }
      ],
      name      = "asc-api-service"
      image     = var.ecr_image
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.my_log_group.name,
          "awslogs-region"        = "us-east-1",
          "awslogs-stream-prefix" = "ecs",
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  tags = {
    name        = "Elastic Container Service Task Definition",
    environment = "dev"

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


