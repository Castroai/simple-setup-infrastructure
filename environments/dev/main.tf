# project/environments/dev/main.tf
module "vpc" {
  source = "../../modules/vpc"
}

module "secrets" {
  source = "../../modules/secrets_manager"
}


module "rds" {
  source            = "../../modules/rds"
  db_name           = "mydatabase" # Provide the name for your database
  db_username       = module.secrets.DATABASE_USERNAME
  db_password       = module.secrets.DATABASE_PASSWORD
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs" {
  source       = "../../modules/ecs_cluster"
  cluster_name = "${var.projectName}-${var.enviorment}-ecs"
}


module "ecr" {
  source          = "../../modules/ecr"
  repository_name = "${var.projectName}-${var.enviorment}-ecr"
}

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs_service" {
  source            = "../../modules/ecs_service"
  cluster_id        = module.ecs.cluster_id
  ecr_image         = module.ecr.repository_url
  vpc_id            = module.vpc.vpc_id
  rds_host_url      = module.rds.rds_host_url
  public_subnet_ids = module.vpc.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
}

