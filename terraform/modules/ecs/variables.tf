variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}
variable "aws_region"{
    type = string
}
variable "cpu" {
  description = "CPU units for the task"
  type        = string
}

variable "memory" {
  description = "Memory in MiB for the task"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the IAM role that the ECS task will use to make AWS API requests"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the IAM role that the ECS task can assume"
  type        = string
}

variable "notification_image" {
  description = "Docker image for the notification API"
  type        = string
}

variable "email_image" {
  description = "Docker image for the email sender"
  type        = string
}

variable "subnets" {
  description = "Subnets for the ECS service"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for the ECS service"
  type        = list(string)
}

variable "desired_count" {
  description = "Desired number of task instances"
  type        = number
  default     = 1
}
variable "target_group_arn" {
  description = "The ARN of the load balancer target group"
  type        = string
}