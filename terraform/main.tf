provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "./modules/vpc"
  cidr_block = var.vpc_cidr_block
}

module "sqs" {
  source = "./modules/sqs"
}

output "sqs_queue_url" {
  value = module.sqs.sqs_queue_url
}

module "ecr" {
  source                        = "./modules/ecr"
  repository_name_notification  = "notification-app"
  repository_name_email         = "email-service-app"
}

output "notification_ecr_repository_url" {
  value = module.ecr.notification_repository_url
}

output "email_service_ecr_repository_url" {
  value = module.ecr.email_service_repository_url
}

module "ses" {
  source           = "./modules/ses"
  sender_email     = "vidhya.inspire01@gmail.com"
  recipient_email  = "thirg01@gmail.com"
}

module "iam" {
  source = "./modules/iam"
}

module "health_check" {
  source                 = "./modules/health_check"
  target_group_name      = "new-notification-api-tg"
  port                   = 3000
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = "/health"
  health_check_interval  = 30
  health_check_timeout   = 5
  healthy_threshold      = 2
  unhealthy_threshold    = 2
  health_check_matcher   = "200-299"
}

module "load_balancer" {
  source                 = "./modules/load_balancer"
  security_groups        = [module.vpc.security_group_id]
  subnets                = module.vpc.public_subnets
  target_group_arn       = module.health_check.target_group_arn  # Pass the target group ARN
}

module "ecs" {
  source              = "./modules/ecs"
  cluster_name        = "notification-cluster"
  cpu                 = "256"
  memory              = "512"
  execution_role_arn  = module.iam.ecs_task_execution_role_arn
  task_role_arn       = module.iam.ecs_task_role_arn
  notification_image  = module.ecr.notification_repository_url
  email_image         = module.ecr.email_service_repository_url
  subnets             = module.vpc.private_subnets
  security_groups     = [module.vpc.security_group_id]
  desired_count       = 2
  target_group_arn    = module.health_check.target_group_arn 
  aws_region          = "us-east-1"
}

module "autoscaling" {
  source             = "./modules/autoscaling"
  max_capacity       = 10
  min_capacity       = 1
  cluster_name       = module.ecs.cluster_name
  service_name       = module.ecs.notification_service_name
  policy_name        = "scale-policy"
  target_value       = 70.0
  scale_in_cooldown  = 300
  scale_out_cooldown = 300
}

module "appmesh" {
  source              = "./modules/appmesh"
  mesh_name           = "my-mesh"
  virtual_node_name   = "notification-node"
  port                = 3000
  namespace_name      = "service.local"
  service_name        = "notification"
  virtual_service_name = "notification.service.local"
}

module "cloudmap" {
  source         = "./modules/cloudmap"
  namespace_name = "service.local"
  vpc_id         = module.vpc.vpc_id
  service_name   = "notification"
  description    = "Private DNS namespace for microservices"
}

output "elb_dns_name" {
  value = module.load_balancer.elb_dns_name
}

module "cloudwatch" {
  source         = "./modules/cloudwatch"
  dashboard_name = "ecs-dashboard"
  widgets        = [
    {
      "type"    = "metric",
      "x"       = 0,
      "y"       = 0,
      "width"   = 12,
      "height"  = 6,
      "properties" = {
        "metrics" = [
          ["AWS/ECS", "CPUUtilization", "ClusterName", module.ecs.cluster_name, { "stat" : "Average" }],
          ["...", "MemoryUtilization", "ClusterName", module.ecs.cluster_name, { "stat" : "Average" }]
        ],
        "period" = 300,
        "stat"   = "Average",
        "region" = var.aws_region,
        "title"  = "ECS Cluster Performance"
      }
    }
  ]
}
