terraform {
  required_version = "~> 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project     = var.project_name
  region      = var.region
  credentials = var.google_credential_file
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
