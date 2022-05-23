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
  description = "API Token generated on Leo's Cloudflare account."
  default     = ""
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "ZoneID on Cloudflare where mindtastic.lol is hosted."
  default     = "9ad94d6aa6113ebb64214ec50fec17bf"
}
