variable "cluster_name" {
  type        = string
  description = "Name of Teleport Kubernetes Cluster."
}

variable "teleport_proxy_address" {
  type        = string
  description = "Address of Teleport Proxy."
}

variable "teleport_auth_token" {
  type        = string
  description = "Static Cluster join token for Teleport."
}
