# Project Name

This project uses Terraform to manage AWS resources. It consists of several modules, each responsible for creating a specific set of resources.

## Modules

### VPC (Virtual Private Cloud)

Located at `../../modules/vpc`. This module is responsible for creating a VPC in AWS. It creates the necessary subnets (both public and private), route tables, and security groups.

### RDS (Relational Database Service)

Located at `../../modules/rds`. This module creates an RDS instance within the VPC. It uses the `private_subnets` output from the VPC module to determine where the RDS instance should be placed.

### ECS (Elastic Container Service)

Located at `../../modules/ecs_cluster`. This module creates an ECS cluster in the VPC. The cluster is used to manage and run Docker containers.

### ECR (Elastic Container Registry)

Located at `../../modules/ecr`. This module creates an ECR repository. ECR is a Docker container registry that makes it easy for you to store, manage, and deploy Docker container images.

### ECS Service Module

This module deploys an ECS service with a task that runs on Fargate.

## Usage

To use these modules, you need to declare them in your `main.tf` file and provide the necessary variables. For example:

```terraform
module "vpc" {
    source = "../../modules/vpc"
    // other necessary variables...
}

module "rds" {
    source = "../../modules/rds"
    // other necessary variables...
}

module "ecs" {
    source = "../../modules/ecs_cluster"
    // other necessary variables...
}

module "ecr" {
    source = "../../modules/ecr"
    // other necessary variables...
}

module "ecs_service" {
  source = "../../modules/ecs_service"

  // ... other variables ...
}
```
# simple-setup-infra
# simple-setup-infrastructure
