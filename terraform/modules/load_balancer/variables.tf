variable "security_groups" {
  description = "List of security group IDs to associate with the ALB"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs to associate with the ALB"
  type        = list(string)
}


variable "target_group_arn" {
  description = "The name of the target group for the ALB"
  type        = string
}


