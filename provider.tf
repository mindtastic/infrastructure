terraform {
  required_version = "~> 1.0"

  backend "remote" {
    organization = "mindtastic"

    workspaces {
      name = "infrastructure-global"
    }
  }

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
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.3"

    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.31.0"
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

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

provider "random" {
}

provider "tfe" {
}
