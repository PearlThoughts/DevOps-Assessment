variable "mesh_name" {
  description = "Name of the App Mesh mesh"
  type        = string
}

variable "virtual_node_name" {
  description = "Name of the virtual node"
  type        = string
}

variable "port" {
  description = "Port for the virtual node"
  type        = number
}

variable "protocol" {
  description = "Protocol for the virtual node"
  type        = string
  default     = "http"
}

variable "namespace_name" {
  description = "Name of the Cloud Map namespace"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Map service"
  type        = string
}

variable "virtual_service_name" {
  description = "Name of the virtual service"
  type        = string
}
