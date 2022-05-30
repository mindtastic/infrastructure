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
    "${file("${path.module}/values.yaml")}"
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
    kubernetes_cluster_role_binding.readonly_group,
    kubernetes_config_map.rbac
  ]
}

resource "kubernetes_cluster_role_binding" "readonly_group" {
  metadata {
    name = "teleport-readonly-group"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view" # Default view role 
  }
  subject {
    kind      = "Group"
    name      = "teleport:readonly"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_config_map" "rbac" {
  metadata {
    name      = local.teleport_release_name
    namespace = local.teleport_namespace
  }

  data = {
    "rbac-config.yaml" = "${templatefile("${path.module}/rbac-config.yaml", {
      teleport_domain               = var.teleport_domain
      teleport_github_client_id     = var.teleport_github_client_id
      teleport_github_client_secret = var.teleport_github_client_secret
      teleport_github_org           = var.teleport_github_org
    })}",
    "teleport.yaml" = "${templatefile("${path.module}/teleport.yaml", {
      teleport_domain          = var.teleport_domain,
      teleport_node_join_token = var.teleport_auth_token,
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
