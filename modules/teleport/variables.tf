variable "kubernetes_cluster_endpoint" {
  type        = string
  description = "Endpoint of Kubernetes Cluster"
}

variable "kubernetes_client_certificate" {
  type        = string
  description = "Client Certificate of Kubernetes Cluster"
  sensitive   = true
}

variable "kubernetes_client_key" {
  type        = string
  description = "Client Key of Kubernetes Cluster"
  sensitive   = true
}

variable "kubernetes_cluster_ca_certificate" {
  type        = string
  description = "Cluster Certificate of Kubernetes Cluster"
  sensitive   = true
}

variable "cluster_name" {
  type        = string
  description = "Name for the Kubernetes Cluster."
}

variable "teleport_domain" {
  type        = string
  description = "Domain for teleport endpoint."
}

variable "teleport_acme_email" {
  type        = string
  description = "Email address for Email notifications from Let's Encrypt."
  sensitive   = true
}

variable "teleport_github_client_id" {
  type        = string
  description = "Client ID of GitHub OAuth app for Teleport login."
}

variable "teleport_github_client_secret" {
  type        = string
  description = "Client Secret of GitHub OAuth app for Teleport login."
  sensitive   = true
}

variable "teleport_github_org" {
  type        = string
  description = "GitHub Organisation for Teleport login."
}
