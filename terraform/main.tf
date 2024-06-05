module "network" {
  source = "./modules/network"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
  notification_image_url = var.notification_image_url
  email_sender_image_url = var.email_sender_image_url
}

module "monitoring" {
  source = "./modules/monitoring"
}

module "scaling" {
  source = "./modules/scaling"
  ecs_cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
}

