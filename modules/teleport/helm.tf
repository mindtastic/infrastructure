locals {
  teleport_namespace    = "teleport"
  teleport_release_name = "teleport"
}

resource "kubernetes_namespace" "teleport" {
  metadata {
    name = local.teleport_namespace
  }
}

resource "helm_release" "teleport" {
  name             = local.teleport_release_name
  repository       = "https://charts.releases.teleport.dev"
  chart            = "teleport-cluster"
  version          = "9.2.3"
  create_namespace = true
  namespace        = local.teleport_namespace
  max_history      = 3

  values = [
    "${file("${path.module}/values-cluster.yaml")}"
  ]

  set {
    name  = "clusterName"
    value = var.teleport_domain
  }

  set {
    name  = "kubeClusterName"
    value = var.cluster_name
  }

  set {
    name  = "acmeEmail"
    value = var.teleport_acme_email
  }

  depends_on = [
    kubernetes_config_map.github
  ]
}

resource "random_uuid" "teleport_node_join_token" {}

resource "kubernetes_config_map" "github" {
  metadata {
    name      = local.teleport_release_name
    namespace = local.teleport_namespace
  }

  data = {
    "k8s-admin.yaml" = "${file("${path.module}/k8s-admin.yaml")}",
    "github.yaml" = "${templatefile("${path.module}/github.yaml", {
      teleport_github_client_id     = var.teleport_github_client_id
      teleport_github_client_secret = var.teleport_github_client_secret
      teleport_domain               = var.teleport_domain
      teleport_github_org           = var.teleport_github_org
    })}",
    "teleport.yaml" = "${templatefile("${path.module}/teleport.yaml", {
      teleport_domain          = var.teleport_domain,
      teleport_node_join_token = random_uuid.teleport_node_join_token.result,
      cluster_name             = var.cluster_name,
      teleport_acme_email      = var.teleport_acme_email,
    })}"
  }

  depends_on = [
    kubernetes_namespace.teleport
  ]
}

data "kubernetes_service" "teleport" {
  metadata {
    name      = local.teleport_release_name
    namespace = local.teleport_namespace
  }

  depends_on = [helm_release.teleport]
}

resource "helm_release" "teleport_agent" {
  name             = local.teleport_release_name
  repository       = "https://charts.releases.teleport.dev"
  chart            = "teleport-agent"
  version          = "9.2.3"
  create_namespace = true
  namespace        = local.teleport_namespace
  max_history      = 3

  values = [
    "${file("${path.module}/values-agent.yaml")}"
  ]

  set_sensitive {
    name  = "authToken"
    value = random_uuid.teleport_node_join_token.result
  }

  set {
    name  = "proxyAddr"
    value = "${var.teleport_domain}:443"
  }

  set {
    name  = "kubeClusterName"
    value = var.cluster_name
  }
}
