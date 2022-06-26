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
    name = "apps"
    value = yamlencode([
      { name : "grafana-${kubernetes_environment_label}", uri : "http://kube-prometheus-stack-grafana:monitoring.svc.cluster.local:3000" },
      { name : "jaeger-${kubernetes_environment_label}", uri : "http://jaeger.linkerd-viz.svc.cluster.local:16686" },
      { name : "linkerd-${kubernetes_environment_label}", uri : "http://web.linkerd-viz.svc.cluster.local:8084" },
    ])
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
