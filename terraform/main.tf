provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"

  name = "devops-assessment-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name = "devops-assessment-cluster"
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets
}
