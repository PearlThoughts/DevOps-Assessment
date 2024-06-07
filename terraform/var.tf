
variable "aws_vpc_name" {
  type    = string
  default = "ecs_vpc"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "207064242653"
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "environment" {
  type    = string
  default = "test"
}

variable "ecs_iam_role_name" {
  type    = string
  default = "ecs_iam_role"
}

variable "aws_ecs_cluster_name" {
  type    = string
  default = "notification_cluster"
}

variable "aws_ecr_repository" {
  type    = string
  default = "notification_service"
}

variable "aws_ecs_task_def_fam" {
  type    = string
  default = "notification_service"
}

variable "fargate_cpu" {
  type    = number
  default = 1024
}

variable "fargate_memory" {
  type    = number
  default = 2048
}

variable "aws_ecs_service_name" {
  type    = string
  default = "notification_service"
}

variable "app_port" {
  type    = number
  default = 80
}

variable "app_count" {
  type    = number
  default = 2
}

variable "ecs_alb_name" {
  type    = string
  default = "ecs_alb"
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "aws_sg_name" {
  type    = string
  default = "ecs_sg"
}

variable "tag" {
  type    = string
  default = "test"
}

variable "ecs_task_execution_role_name" {
  type    = string
  default = "ecs_task_execution_role"
}

variable "max_count" {
  type    = number
  default = 10
}

variable "min_count" {
  type    = number
  default = 1
}

variable "autoscaling_cpu_target" {
  type    = number
  default = 70
}