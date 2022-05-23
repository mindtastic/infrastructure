variable "environment" {
  type        = string
  description = "Environment Name"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "The region we want to deploy our cluster in"
  default     = "europe-north1"
}

variable "k8s_node_subnet" {
  type        = string
  description = "Subnet for Kubernetes Nodes"
}

variable "k8s_pod_subnet" {
  type        = string
  description = "Subnet for Kubernetes Pods"
}

variable "k8s_service_subnet" {
  type        = string
  description = "Subnet for Kubernetes Services"
}

variable "k8s_control_plane_subnet" {
  type        = string
  description = "Subnet for Kubernetes Control Plane"
}

variable "cluster_node_type" {
  type        = string
  description = "Node Type for Kubernetes Nodes"
}

variable "cluster_node_count" {
  type        = number
  description = "Node Count for Kubernetes Nodes"
}

