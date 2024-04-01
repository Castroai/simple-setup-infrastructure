resource "aws_codedeploy_app" "example" {
  name             = "example-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "example" {
  app_name               = aws_codedeploy_app.example.name
  deployment_group_name  = "example-deployment-group"
  service_role_arn       = aws_iam_role.example.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  ecs_service {
    cluster_name = var.aws_ecs_cluster
    service_name = var.service_name
  }
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.aws_lb_listener_arn]
      }
      target_group {
        name = var.aws_lb_target_group
      }
    }

  }
}

resource "aws_iam_role" "example" {
  name               = "example-codedeploy-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codedeploy.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForECS"
}

resource "aws_s3_bucket" "appspec_bucket" {
  bucket = "example-appspec-bucket"
}
