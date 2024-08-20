variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "notification-api"
}

variable "vpc_id" {
  description = "VPC ID where the ECS cluster to be deployed"
  type        = string
}

