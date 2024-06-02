variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default = "vpc-0fb809d348139ac47"
}

variable "subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default = ["subnet-03b108e1dafc6f9e5","subnet-0f47b25e174d49d09"]
}