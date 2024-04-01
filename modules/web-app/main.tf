
# Purpose: Create an ECR repository
resource "aws_ecr_repository" "ecr_repo" {
  name = "web-app-dev-ecr"
  tags = {
    Name        = "Elastic Continer Repository"
    Environment = "dev"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  depends_on = [aws_cloudwatch_log_group.my_log_group]
  family     = "client-web-service"
  container_definitions = jsonencode([
    {
      environment = [],
      name        = "client-web-service"
      image       = aws_ecr_repository.ecr_repo.repository_url
      essential   = true
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
  execution_role_arn = var.ecs_execution_role_arn
  tags = {
    Name        = "Elastic Container Service Task Definition For Web App",
    Environment = "dev"

  }
}

# CloudWatch log group
resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/ecs/client-web-service"
  tags = {
    Name        = "CloudWatch Log Group"
    Environment = "dev"

  }
}
# ECS Service with load balancer and security group
resource "aws_ecs_service" "my_service" {
  name                = "${var.projectName}-${var.enviorment}-ecs-service"
  cluster             = var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.my_task.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  # deployment_controller {
  #   type = "CODE_DEPLOY"
  # }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "client-web-service"
    container_port   = 80
  }
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_tasks_sg_id]
    assign_public_ip = true
  }

  desired_count        = 1
  force_new_deployment = true
  tags = {
    Name        = "ECS Service Client"
    Environment = "dev"

  }
}

