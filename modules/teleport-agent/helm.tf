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
    name = "apps[0].name"
    value = "grafana-${var.kubernetes_environment_label}"
  }

  set {
    name = "apps[0].uri"
    value = "http://kube-prometheus-stack-grafana.monitoring.svc.cluster.local:80"
  }

  # The following two are necessary to fix Grafana Websocket upgrading and other stuff. Took me ages to find...
  set {
    name = "apps[0].public_addr"
    value = "grafana-${var.kubernetes_environment_label}.${var.teleport_proxy_address}"
  }

  set {
    name = "apps[0].rewrite.headers[0]"
    value = "grafana-${var.kubernetes_environment_label}.${var.teleport_proxy_address}"
  }

  set {
    name = "apps[1].name"
    value = "jaeger-${var.kubernetes_environment_label}"
  }

  set {
    name = "apps[1].uri"
    value = "http://jaeger.linkerd-viz.svc.cluster.local:16686"
  }

  set {
    name = "apps[2].name"
    value = "linkerd-${var.kubernetes_environment_label}"
  }

  set {
    name = "apps[2].uri"
    value = "http://web.linkerd-viz.svc.cluster.local:8084"
  }

  set {
    name  = "labels.env"
    value = var.kubernetes_environment_label
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
