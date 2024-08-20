variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "policy_name" {
  description = "Name of the scaling policy"
  type        = string
}

variable "target_value" {
  description = "Target value for the scaling policy"
  type        = number
  default     = 70.0
}

variable "scale_in_cooldown" {
  description = "Cooldown period after scaling in"
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Cooldown period after scaling out"
  type        = number
  default     = 300
}
