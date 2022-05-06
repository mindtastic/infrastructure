variable "google_credential_file" {
  type        = string
  description = "Authentication key for Google Cloud (JSON)"
  default     = ""
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
