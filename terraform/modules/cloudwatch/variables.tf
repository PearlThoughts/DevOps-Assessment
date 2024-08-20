variable "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  type        = string
}

variable "widgets" {
  description = "Widgets for the CloudWatch dashboard"
  type        = list(any)
}
