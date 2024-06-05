variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs"
  type        = list(string)
}

variable "notification_image_url" {
  description = "ECR URL for Notification API"
  type        = string
}

variable "email_sender_image_url" {
  description = "ECR URL for Email Sender"
  type        = string
}

