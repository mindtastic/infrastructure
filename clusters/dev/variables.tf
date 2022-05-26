variable "google_credential_file" {
  type        = string
  description = "Authentication key for Google Cloud (JSON)."
  sensitive   = true
}

variable "cloudflare_api_token" {
  type        = string
  description = "API Token to access the cloudflare API for the given zone id."
  sensitive   = true
}

variable "project_name" {
  type        = string
  description = "Project name on Google Cloud."
}

variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "region" {
  type        = string
  description = "The region we want to deploy our cluster in"
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

