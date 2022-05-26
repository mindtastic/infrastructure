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
  chart            = "teleport-kube-agent"
  version          = "9.2.3"
  create_namespace = true
  namespace        = local.teleport_namespace
  max_history      = 3

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  set {
    name  = "proxyAddr"
    value = var.teleport_proxy_address
  }

  set {
    name  = "kubeClusterName"
    value = var.cluster_name
  }

  set_sensitive {
    name  = "authToken"
    value = var.teleport_auth_token
  }

  depends_on = [
    kubernetes_cluster_role_binding.readonly_group
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

data "kubernetes_service" "teleport" {
  metadata {
    name      = local.teleport_release_name
    namespace = local.teleport_namespace
  }

  depends_on = [helm_release.teleport]
}
