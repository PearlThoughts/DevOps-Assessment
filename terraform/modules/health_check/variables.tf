variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "port" {
  description = "Port for the target group"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID where the target group is created"
  type        = string
}

variable "health_check_path" {
  description = "Path for the health check"
  type        = string
}

variable "health_check_interval" {
  description = "Interval for the health check in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout for the health check in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Healthy threshold for the health check"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold for the health check"
  type        = number
  default     = 2
}

variable "health_check_matcher" {
  description = "HTTP status code matcher for the health check"
  type        = string
  default     = "200-299"
}
