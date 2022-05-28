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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.3"

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

data "google_client_config" "default" {}

provider "tfe" {
  token = var.tfc_token
}

provider "random" {
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.live_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.live_cluster.master_auth[0].cluster_ca_certificate)
}
