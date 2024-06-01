variable "region" {
  description = "The AWS region to deploy to."
  type        = string
}

variable "subnet_ids" {
  description = "The subnets associated with your ECS tasks."
  type        = list(string)
}

variable "security_group_ids" {
  description = "The security groups associated with your ECS tasks."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where resources will be created."
  type        = string
}

variable "min_task_count" {
  description = "The minimum number of ECS tasks."
  default     = 1
}

variable "max_task_count" {
  description = "The maximum number of ECS tasks."
  default     = 10
}

variable "desired_task_count" {
  description = "The desired number of ECS tasks."
  default     = 2
}

variable "target_cpu_utilization" {
  description = "The target CPU utilization percentage for autoscaling."
  default     = 70
}