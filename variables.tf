variable "google_credential_file" {
  type        = string
  description = "Authentication key for Google Cloud (JSON)."
  default     = ""
  sensitive   = true
}

variable "tfc_token" {
  type        = string
  description = "API Token for Terraform Cloud"
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
  default     = "europe-north1"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API Token to access the cloudflare API for the given zone id."
  default     = ""
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "ZoneID on Cloudflare where mindtastic.lol is hosted."
  default     = "9ad94d6aa6113ebb64214ec50fec17bf"
}

variable "root_domain_name" {
  type        = string
  description = "Name of the root domain for the zone that referenced by cloudflare_zone_id"
  default     = "mindtastic.lol"
}

variable "live_runtime_teleport_acme_email" {
  type      = string
  sensitive = true
}

variable "live_runtime_teleport_github_client_id" {
  type      = string
  sensitive = true
}

variable "live_runtime_teleport_github_client_secret" {
  type      = string
  sensitive = true
}

variable "live_runtime_teleport_domain" {
  type      = string
  sensitive = true
}

variable "live_runtime_teleport_github_org" {
  type      = string
  sensitive = true
}

variable "live_runtime_argocd_github_client_id" {
  type      = string
  sensitive = true
}

variable "live_runtime_argocd_github_client_secret" {
  type      = string
  sensitive = true
}

variable "live_runtime_argocd_github_private_key" {
  type      = string
  sensitive = true
}

variable "TFC_WORKSPACE_NAME" {
  type        = string
  description = "The name of the workspace used in this run."
  default     = "infrastructure"
}
