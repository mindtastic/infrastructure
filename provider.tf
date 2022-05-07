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
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
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

provider "helm" {
  kubernetes {
    host = google_container_cluster.primary.endpoint

    client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
    client_key             = google_container_cluster.primary.master_auth.0.client_key
    cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  }
}
