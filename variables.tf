variable "google_credential_file" {
  type        = string
  description = "Authentication key for Google Cloud (JSON)."
  default     = ""
  sensitive   = true
}

variable "project_name" {
  type        = string
  description = "Project name on Google Cloud."
  default     = "opentelemetry-benchmark"
}

variable "region" {
  type        = string
  description = "The region we want to deploy our cluster in."
  default     = "europe-west3"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API Token generated on Leo's Cloudflare account."
  default     = ""
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "ZoneID on Cloudflare where mindtastic.lol is hosted."
  default     = "9ad94d6aa6113ebb64214ec50fec17bf"
}

variable "cluster_name" {
  type        = string
  description = "Name for the Kubernetes Cluster."
  default     = "live-mindtastic"
}

variable "teleport_domain" {
  type        = string
  description = "Domain for teleport endpoint."
  default     = "teleport.mindtastic.lol"
}

variable "teleport_acme_email" {
  type        = string
  description = "Email address for Email notifications from Let's Encrypt."
  default     = ""
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
  default     = "mindtastic"
}
