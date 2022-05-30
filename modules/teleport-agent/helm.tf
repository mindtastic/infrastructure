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
    value = "${var.teleport_proxy_address}:443" # It it sufficient to point to the auth-service (https://goteleport.com/docs/kubernetes-access/getting-started/agent/)
  }

  set {
    name  = "kubeClusterName"
    value = var.cluster_name
  }

  set {
    name = "labels"
    value = yamlencode({
      env = var.kubernetes_environment_label
    })
  }

  set_sensitive {
    name  = "authToken"
    value = var.teleport_auth_token
  }

  depends_on = [
    kubernetes_cluster_role_binding.readonly_group
  ]
}

resource "kubernetes_role" "customer_view" {
  metadata {
    name = "customer-view"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "ingress", "nodes", "configmaps", "endpoints"]
    verbs      = ["get", "watch", "list"]
  }
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

resource "kubernetes_cluster_role_binding" "customer_readonly_group" {
  metadata {
    name = "teleport-readonly-customer-group"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "customer-view"
  }
  subject {
    kind      = "Group"
    name      = "teleport:customer"
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
