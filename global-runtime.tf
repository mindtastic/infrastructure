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

  # Maps clusters/{dev|stage}/runtime.tf
  argocd_sa_name      = "argocd-manager"
  argocd_sa_namespace = "kube-system"
}

data "kubernetes_service_account" "dev_argocd_manager" {
  count    = local.dev_cluster_exists ? 1 : 0
  provider = kubernetes.dev_cluster

  metadata {
    name      = local.argocd_sa_name
    namespace = local.argocd_sa_namespace
  }
}

data "kubernetes_secret" "dev_argocd_credentials" {
  count    = local.dev_cluster_exists ? 1 : 0
  provider = kubernetes.dev_cluster

  metadata {
    name = data.kubernetes_service_account.dev_argocd_manager[0].default_secret_name
  }
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
      "bearerToken" = data.kubernetes_secret.dev_argocd_credentials[0].binary_data["token"],
      "tlsClientConfig" = {
        "insecure"   = false,
        "caData"     = data.kubernetes_secret.dev_argocd_credentials[0].binary_data["ca.crt"],
        "serverName" = "kubernetes.default.svc.cluster.local",
      }
    })
  }

  depends_on = [
    data.kubernetes_secret.dev_argocd_credentials
  ]
}

data "kubernetes_service_account" "stage_argocd_manager" {
  count    = local.stage_cluster_exists ? 1 : 0
  provider = kubernetes.stage_cluster

  metadata {
    name      = local.argocd_sa_name
    namespace = local.argocd_sa_namespace
  }
}

data "kubernetes_secret" "stage_argocd_credentials" {
  count    = local.stage_cluster_exists ? 1 : 0
  provider = kubernetes.stage_cluster

  metadata {
    name = data.kubernetes_service_account.stage_argocd_manager[0].secret[0].name
  }
}

output "argocd_sa_dev_default_secret_name" {
  value = data.kubernetes_service_account.dev_argocd_manager[0].default_secret_name
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
      "bearerToken" = data.kubernetes_secret.stage_argocd_credentials[0].binary_data["token"],
      "tlsClientConfig" = {
        "insecure"   = false,
        "caData"     = data.kubernetes_secret.stage_argocd_credentials[0].binary_data["ca.crt"],
        "serverName" = "kubernetes.default.svc.cluster.local",
      }
    })
  }
}

