variable "aws_region" {
  description = "The AWS region  to deploy the scalable notification service resources"
  default     = "us-east-1"
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}