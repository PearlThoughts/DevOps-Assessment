
module "vpc" {
  source = "./vpc"
}

module "ecr" {
  source = "./ecr.tf"
}

module "cluster" {
  source = "./cluster.tf"
}

module "secrets_manager" {
  source = "./secrets_manager.tf"
}

module "iam" {
  source = "./iam"
}

module "service" {
  source         = "./service.tf"
  cluster_name   = module.cluster.cluster_name
  ecr_repo_name  = module.ecr.repo_name
  email_secret   = module.secrets_manager.email_secret_arn
  subnets        = module.vpc.public_subnets
  security_group = module.vpc.security_group_id
  execution_role = module.iam.ecs_task_execution_role_arn
}

module "autoscaling" {
  source       = "./autoscaling.tf"
  service_name = "module.service.service_name"
  cluster_name = "module.cluster.cluster_name"
}

module "observability" {
  source                        = "./observability.tf"
  cluster_name                  = module.cluster.cluster_name
  notification_api_service_name = module.service.notification_api_service_name
  email_sender_service_name     = module.service.email_sender_service_name
}
