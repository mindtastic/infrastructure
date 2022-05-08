terraform {
  required_version = "~> 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes_cluster_endpoint
    client_certificate     = var.kubernetes_client_certificate
    client_key             = var.kubernetes_client_key
    cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = var.kubernetes_cluster_endpoint
  client_certificate     = var.kubernetes_client_certificate
  client_key             = var.kubernetes_client_key
  cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
}
