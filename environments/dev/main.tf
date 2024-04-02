provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
}

module "ecs" {
  source                          = "../../modules/ecs_cluster"
  cluster_name                    = "simple-setup-ecs-cluster"
  vpc_id                          = module.vpc.vpc_id
  load_balancer_security_group_id = module.alb.security_group_id
}

module "simple_setup_web_app" {
  source                 = "../../modules/web-app"
  ecs_cluster_id         = module.ecs.cluster_id
  ecs_tasks_sg_id        = module.ecs.ecs_tasks_sg_id
  target_group_arn       = module.alb.client_target_group_arn
  ecs_execution_role_arn = module.ecs.ecs_execution_role_arn
  private_subnet_ids     = module.vpc.private_subnet_ids
}

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}


module "assertion_consumer_service" {
  source                 = "../../modules/assertion-consumer-service"
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_id                 = module.vpc.vpc_id
  ecs_cluster_id         = module.ecs.cluster_id
  ecs_execution_role_arn = module.ecs.ecs_execution_role_arn
  ecs_tasks_sg_id        = module.ecs.ecs_tasks_sg_id
  target_group_arn       = module.alb.api_target_group_arn
}
