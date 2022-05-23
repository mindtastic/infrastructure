terraform {
  required_version = "~> 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    }
  }
}

provider "google" {
  project     = var.project_name
  region      = var.region
  credentials = var.google_credential_file
}

data "google_client_config" "default" {}
