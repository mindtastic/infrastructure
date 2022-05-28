# Teleport

resource "random_uuid" "teleport_node_join_token" {}

# ArgoCD

data "google_container_cluster" "live_cluster" {
  name     = "live-gke-europe-north1" # Matches clusters/live/cluster.tf
  location = var.region
}

data "google_container_cluster" "dev_cluster" {
  name     = "dev-gke-europe-north1"
  location = var.region
}

data "google_container_cluster" "stage_cluster" {
  name     = "stage-gke-europe-north1"
  location = var.region
}

locals {
  # GCP data provider returns an object where google_compute_networks where all
  # string attributes are set to tostring(null) if empty or networks not exist.
  live_cluster_exists  = data.google_container_cluster.live_cluster.self_link != tostring(null)
  dev_cluster_exists   = data.google_container_cluster.dev_cluster.self_link != tostring(null)
  stage_cluster_exists = data.google_container_cluster.stage_cluster.self_link != tostring(null)

  live_stage_cluster_exists = local.live_cluster_exists && local.stage_cluster_exists
  live_dev_cluster_exists   = local.live_cluster_exists && local.dev_cluster_exists
}

# Based on https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#clusters
resource "kubernetes_secret" "argocd_dev_cluster_secret" {
  count = local.live_dev_cluster_exists ? 1 : 0

  metadata {
    name      = "argocd-dev-cluster-secret"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = "dev-cluster",
    server = "https://cluster.net.dev.mindtastic.lol",
    config = jsonencode({
      "bearerToken" = data.google_client_config.default.access_token,
      "tlsClientConfig" = {
        "insecure"   = false,
        "caData"     = data.google_container_cluster.dev_cluster.master_auth[0].cluster_ca_certificate,
        "serverName" = "kubernetes.default.svc.cluster.local",
      }
    })
  }
}

resource "kubernetes_secret" "argocd_stage_cluster_secret" {
  count = local.live_stage_cluster_exists ? 1 : 0

  metadata {
    name      = "argocd-stage-cluster-secret"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = "stage-cluster",
    server = "https://cluster.net.stage.mindtastic.lol",
    config = jsonencode({
      "bearerToken" = data.google_client_config.default.access_token,
      "tlsClientConfig" = {
        "insecure"   = false,
        "caData"     = data.google_container_cluster.stage_cluster.master_auth[0].cluster_ca_certificate,
        "serverName" = "kubernetes.default.svc.cluster.local",
      }
    })
  }
}

