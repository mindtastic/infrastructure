variable "tfc_organization" {
  type        = string
  description = "Terraform Cloud Organization name"
}

variable "google_credential_file" {
  type        = string
  description = "Authentication key for Google Cloud (JSON)."
  sensitive   = true
}

variable "tfc_token" {
  type        = string
  description = "API Token for Terraform Cloud"
  sensitive   = true
}

variable "cloudflare_api_token" {
  type        = string
  description = "API Token to access the cloudflare API for the given zone id."
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "ZoneID on Cloudflare where mindtastic.lol is hosted."
  default     = "9ad94d6aa6113ebb64214ec50fec17bf"
}

variable "project_name" {
  type        = string
  description = "Project name on Google Cloud."
}

variable "region" {
  type        = string
  description = "The region we want to deploy our cluster in"
}

variable "dev_workspace_name" {
  type        = string
  description = "TFC Workspace name for dev Cluster"
}

variable "stage_workspace_name" {
  type        = string
  description = "TFC Workspace name for stage Cluster"
}

variable "live_workspace_name" {
  type        = string
  description = "TFC Workspace name for live Cluster"
}
