variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "notification_api_image" {
  description = "Docker image for Notification API"
  type        = string
}

variable "email_sender_image" {
  description = "Docker image for Email Sender"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization threshold for auto-scaling."
  type        = number
  default     = 70
}
