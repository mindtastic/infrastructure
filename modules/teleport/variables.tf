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
