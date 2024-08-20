variable "namespace_name" {
  description = "Name of the Cloud Map namespace"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the namespace is created"
  type        = string
}

variable "description" {
  description = "Description of the Cloud Map namespace"
  type        = string
}

variable "service_name" {
  description = "Name of the service in Cloud Map"
  type        = string
}

variable "ttl" {
  description = "TTL for the DNS records"
  type        = number
  default     = 60
}

variable "failure_threshold" {
  description = "Failure threshold for health checks"
  type        = number
  default     = 1
}
